# NotaKilat

Aplikasi pencatat pesanan, tagihan, DP, dan pelunasan untuk reseller dan usaha kecil (UMKM).
Tugas Kelompok 7, Teknologi Berkembang 2026/2027

## Anggota
Crystal Reinheart, Raid Orlando Azurae, Nail Ayyasy, Syahdu Szenovera Maharani,
Muhammad Izzan Aquilla, Rizqullah Arsyad, Miftahul Arifin Sofyan

## Cara menjalankan
1. Install Git dan Flutter (versi 3.38.10 atau lebih baru), cek dengan `flutter doctor`
2. `git clone https://github.com/dreadf/nota_kilat.git`
3. `cd nota_kilat`
4. `flutter pub get`
5. `flutter run -d chrome` (atau pilih emulator Android)

## Aturan kerja
- Jangan kerja langsung di `main`. Buat branch sendiri: `git checkout -b feat/nama-fitur`
- Commit, push, lalu buka Pull Request di GitHub.
- Jangan jalankan `flutter pub add` (takut ada conflict version, bilang dulu di group)
- Kunci rahasia (service_role) tidak boleh masuk repo.
- Pesan commit bahasa Inggris dengan format `jenis: deskripsi singkat`.
  Jenis: `feat` (fitur baru), `fix` (perbaiki bug), `docs` (dokumentasi), `chore` (setup/rawat project), `refactor` (rapikan kode).
  Contoh: `feat: add product list screen`. Nama branch mengikuti jenis yang sama: `feat/produk`, `fix/stok`.

## Struktur folder

Kode ada di folder `lib/` dan dikelompokkan **per fitur** (feature-first), bukan per jenis file.
Alasannya:
- Satu fitur = satu folder, jadi tiap anggota mengerjakan folder sendiri dan konflik merge jarang terjadi.
- Mencari kode mudah. Bug soal pembayaran? Buka `features/transactions/`.
- Kode yang dipakai banyak fitur dikumpulkan di `core/`, jadi tidak ada kode ganda.

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   ├── services/
│   ├── utils/
│   └── widgets/
└── features/
    ├── auth/            (screens, widgets, services)
    ├── dashboard/       (screens, widgets, services)
    ├── products/        (screens, widgets, models, services)
    ├── customers/       (screens, widgets, models, services)
    ├── transactions/    (screens, widgets, models, services)
    └── profile/         (screens, widgets, services)
```

### File di root `lib/`
| File | Isi |
|---|---|
| `main.dart` | Titik awal app: menyiapkan Supabase lalu menjalankan `runApp()`. Dibuat singkat |
| `app.dart` | `MaterialApp`: tema, rute, dan layar pertama (Splash) |

### `core/` (dipakai oleh semua fitur)
| Folder | Isi | Contoh |
|---|---|---|
| `theme/` | Warna dan gaya teks, diambil dari design system di Figma | `app_colors.dart`, `app_theme.dart` |
| `services/` | Satu koneksi Supabase yang dipakai bersama | `supabase_client.dart` |
| `utils/` | Fungsi kecil pembantu tanpa tampilan | `formatters.dart` (Rupiah, tanggal), `validators.dart` (cek isian form) |
| `widgets/` | Komponen tampilan yang dipakai lebih dari satu fitur | `loading_view.dart`, `empty_view.dart`, `error_view.dart`, `confirm_delete_dialog.dart`, `status_badge.dart` |

### `features/` (satu folder per fitur)
| Fitur | Layar yang dicakup |
|---|---|
| `auth/` | Splash, Login, Register |
| `dashboard/` | Dashboard (tagihan belum lunas, pengingat jatuh tempo, transaksi terbaru) |
| `products/` | Daftar Produk, Detail Produk, Tambah/Edit Produk, dialog tambah stok |
| `customers/` | Daftar Pelanggan, Detail Pelanggan, Tambah/Edit Pelanggan |
| `transactions/` | Daftar Transaksi, Buat Transaksi, Detail Transaksi (nota), dialog catat pembayaran, bagikan PDF |
| `profile/` | Profil Usaha, ubah password, logout |

Isi subfolder di dalam setiap fitur:
| Subfolder | Isi | Contoh (fitur products) |
|---|---|---|
| `screens/` | Satu file = satu layar penuh | `product_list_screen.dart` |
| `widgets/` | Potongan tampilan yang hanya dipakai fitur ini | `product_card.dart` |
| `models/` | Bentuk data (class Dart) yang cocok dengan tabel database | `product.dart` |
| `services/` | Kode yang bicara dengan Supabase (ambil, tambah, ubah, hapus) | `product_service.dart` |

Catatan: `auth/`, `dashboard/`, dan `profile/` tidak punya `models/` karena tidak punya tabel sendiri
(login memakai Supabase Auth, dashboard membaca data fitur lain, profil disimpan di user metadata).
Subfolder tambahan boleh dibuat kalau dibutuhkan.

### Aturan
1. **Layar tidak memanggil Supabase langsung.** Selalu lewat `services/`. Kalau database berubah, hanya `services/` yang diubah.
2. Komponen yang dipakai lebih dari satu fitur dipindah ke `core/widgets/`.
3. Satu orang memegang satu fitur. Mengubah file di fitur orang lain? Bilang dulu