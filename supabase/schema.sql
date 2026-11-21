-- NotaKilat: skema database Supabase
-- Cara pakai: Supabase Dashboard > SQL Editor > New query > tempel seluruh file > Run.
-- Jalankan SEKALI pada project kosong. Mengubah skema nanti: tambah file baru di folder ini
-- (contoh: 002_add_kolom.sql), jangan edit file ini setelah dijalankan.
--
-- Aturan:
--  * Semua tabel punya user_id + RLS: tiap akun hanya melihat datanya sendiri.
--  * Status transaksi TIDAK disimpan; dihitung di app dari total dan jumlah payments.
--  * Uang disimpan sebagai bilangan bulat Rupiah (bigint), tanpa desimal.

-- ============================================================
-- 1. TABEL
-- ============================================================

create table public.customers (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  nama       text not null check (length(trim(nama)) > 0),
  no_wa      text not null check (no_wa ~ '^[0-9]+$'),
  alamat     text,
  created_at timestamptz not null default now()
);

create table public.products (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  nama       text not null check (length(trim(nama)) > 0),
  harga      bigint not null check (harga > 0),
  stok       integer not null check (stok >= 0),
  created_at timestamptz not null default now()
);

create table public.transactions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  -- restrict: pelanggan yang masih punya transaksi tidak bisa dihapus
  customer_id uuid not null references public.customers (id) on delete restrict,
  nomor       text not null,
  tanggal     date not null default current_date,
  due_date    date,
  diskon      bigint not null default 0 check (diskon >= 0),
  total       bigint not null check (total >= 0),
  catatan     text,
  created_at  timestamptz not null default now(),
  unique (user_id, nomor),
  check (due_date is null or due_date >= tanggal)
);

create table public.transaction_items (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null default auth.uid() references auth.users (id) on delete cascade,
  transaction_id uuid not null references public.transactions (id) on delete cascade,
  -- set null: produk boleh dihapus, nota tetap menyimpan salinan nama dan harga
  product_id     uuid references public.products (id) on delete set null,
  nama_produk    text not null,
  harga          bigint not null check (harga >= 0),
  qty            integer not null check (qty >= 1),
  subtotal       bigint not null check (subtotal >= 0)
);

create table public.payments (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null default auth.uid() references auth.users (id) on delete cascade,
  transaction_id uuid not null references public.transactions (id) on delete cascade,
  nominal        bigint not null check (nominal > 0),
  tanggal        date not null default current_date,
  created_at     timestamptz not null default now()
);

-- Indeks untuk RLS dan relasi
create index customers_user_id_idx          on public.customers (user_id);
create index products_user_id_idx           on public.products (user_id);
create index transactions_user_id_idx       on public.transactions (user_id);
create index transactions_customer_id_idx   on public.transactions (customer_id);
create index transaction_items_user_id_idx  on public.transaction_items (user_id);
create index transaction_items_trx_idx      on public.transaction_items (transaction_id);
create index transaction_items_product_idx  on public.transaction_items (product_id);
create index payments_user_id_idx           on public.payments (user_id);
create index payments_trx_idx               on public.payments (transaction_id);

-- ============================================================
-- 2. RLS (Row Level Security)
-- Satu aturan seragam: hanya baris milik pengguna yang login.
-- ============================================================

alter table public.customers         enable row level security;
alter table public.products          enable row level security;
alter table public.transactions      enable row level security;
alter table public.transaction_items enable row level security;
alter table public.payments          enable row level security;

create policy "own rows" on public.customers
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "own rows" on public.products
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "own rows" on public.transactions
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "own rows" on public.transaction_items
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "own rows" on public.payments
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- ============================================================
-- 3. FUNGSI (RPC): dipanggil dari Flutter dengan supabase.rpc('nama', params: {...})
-- Berjalan sebagai pengguna yang login (security invoker), jadi RLS tetap berlaku.
-- Semua langkah dalam satu fungsi = berhasil semua atau gagal semua.
-- ============================================================

-- Buat transaksi: simpan nota, item, DP (jika ada), kurangi stok, nomor otomatis.
-- p_items contoh: [{"product_id": "uuid", "qty": 2}, ...]
-- Harga diambil dari tabel products (bukan dari app). Produk yang sama digabung qty-nya.
-- Mengembalikan id transaksi baru.
create or replace function public.create_transaction(
  p_customer_id uuid,
  p_tanggal     date,
  p_due_date    date,
  p_diskon      bigint,
  p_catatan     text,
  p_dp          bigint,
  p_items       jsonb
) returns uuid
language plpgsql
set search_path = public
as $$
declare
  v_uid      uuid := auth.uid();
  v_tid      uuid;
  v_tanggal  date := coalesce(p_tanggal, current_date);
  v_diskon   bigint := coalesce(p_diskon, 0);
  v_dp       bigint := coalesce(p_dp, 0);
  v_subtotal bigint := 0;
  v_total    bigint;
  v_seq      integer;
  v_nomor    text;
  v_prefix   text;
  v_item     record;
  v_prod     public.products%rowtype;
begin
  if v_uid is null then
    raise exception 'Belum login';
  end if;
  if not exists (select 1 from customers where id = p_customer_id) then
    raise exception 'Pelanggan tidak ditemukan';
  end if;
  if p_items is null or jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'Minimal 1 item';
  end if;
  if p_due_date is not null and p_due_date < v_tanggal then
    raise exception 'Jatuh tempo tidak boleh sebelum tanggal transaksi';
  end if;

  -- Cegah dua transaksi bersamaan mendapat nomor yang sama
  perform pg_advisory_xact_lock(hashtext(v_uid::text));

  -- Langkah 1: validasi item dan hitung subtotal (produk dikunci agar stok tidak balapan)
  for v_item in
    select (e ->> 'product_id')::uuid as product_id, sum((e ->> 'qty')::integer) as qty
    from jsonb_array_elements(p_items) e
    group by 1
  loop
    select * into v_prod from products where id = v_item.product_id for update;
    if not found then
      raise exception 'Produk tidak ditemukan';
    end if;
    if v_item.qty < 1 then
      raise exception 'Qty minimal 1 (%)', v_prod.nama;
    end if;
    if v_item.qty > v_prod.stok then
      raise exception 'Stok % tidak cukup (sisa %)', v_prod.nama, v_prod.stok;
    end if;
    v_subtotal := v_subtotal + v_item.qty * v_prod.harga;
  end loop;

  if v_diskon < 0 or v_diskon > v_subtotal then
    raise exception 'Diskon tidak boleh melebihi subtotal';
  end if;
  v_total := v_subtotal - v_diskon;
  if v_dp < 0 or v_dp > v_total then
    raise exception 'DP tidak boleh melebihi total';
  end if;

  -- Nomor: TRX-TahunBulan-urutan, contoh TRX-202611-0001
  -- Urutan = nomor terbesar bulan itu + 1 (sama dengan jumlah transaksi + 1 jika tidak ada yang dihapus;
  -- memakai nomor terbesar agar tidak bentrok setelah ada transaksi yang dihapus).
  v_prefix := 'TRX-' || to_char(v_tanggal, 'YYYYMM') || '-';
  select coalesce(max(substring(nomor from '[0-9]+$')::integer), 0) + 1
    into v_seq
    from transactions
   where nomor like v_prefix || '%';
  v_nomor := v_prefix || lpad(v_seq::text, 4, '0');

  insert into transactions (customer_id, nomor, tanggal, due_date, diskon, total, catatan)
  values (p_customer_id, v_nomor, v_tanggal, p_due_date, v_diskon, v_total, p_catatan)
  returning id into v_tid;

  -- Langkah 2: simpan item (salinan nama dan harga) dan kurangi stok
  for v_item in
    select (e ->> 'product_id')::uuid as product_id, sum((e ->> 'qty')::integer) as qty
    from jsonb_array_elements(p_items) e
    group by 1
  loop
    select * into v_prod from products where id = v_item.product_id;
    insert into transaction_items (transaction_id, product_id, nama_produk, harga, qty, subtotal)
    values (v_tid, v_prod.id, v_prod.nama, v_prod.harga, v_item.qty, v_item.qty * v_prod.harga);
    update products set stok = stok - v_item.qty where id = v_prod.id;
  end loop;

  -- Langkah 3: DP = pembayaran pertama
  if v_dp > 0 then
    insert into payments (transaction_id, nominal, tanggal) values (v_tid, v_dp, v_tanggal);
  end if;

  return v_tid;
end;
$$;

-- Hapus transaksi: kembalikan stok (item yang produknya sudah dihapus dilewati),
-- lalu hapus transaksi beserta item dan pembayarannya (ON DELETE CASCADE).
create or replace function public.delete_transaction(p_id uuid)
returns void
language plpgsql
set search_path = public
as $$
begin
  if not exists (select 1 from transactions where id = p_id) then
    raise exception 'Transaksi tidak ditemukan';
  end if;

  update products p
     set stok = p.stok + i.qty
    from transaction_items i
   where i.transaction_id = p_id
     and i.product_id = p.id;

  delete from transactions where id = p_id;
end;
$$;

-- Hanya pengguna yang login yang boleh memanggil fungsi
revoke execute on function public.create_transaction(uuid, date, date, bigint, text, bigint, jsonb) from public, anon;
revoke execute on function public.delete_transaction(uuid) from public, anon;
grant  execute on function public.create_transaction(uuid, date, date, bigint, text, bigint, jsonb) to authenticated;
grant  execute on function public.delete_transaction(uuid) to authenticated;

-- ============================================================
-- 4. PENGECEKAN (jalankan terpisah setelah semua di atas sukses)
-- Semua baris harus rowsecurity = true:
--   select tablename, rowsecurity from pg_tables where schemaname = 'public';
-- ============================================================
