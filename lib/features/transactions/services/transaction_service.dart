import '../../../core/services/service_exception.dart';
import '../../../core/services/supabase_client.dart';
import '../models/transaction.dart';
import '../models/transaction_item.dart';

/// Semua akses data transaksi. Layar hanya memanggil fungsi di sini,
/// tidak boleh memanggil Supabase langsung.
///
/// Semua fungsi melempar [ServiceException] kalau gagal; pesannya siap
/// ditampilkan ke pengguna.
class TransactionService {
  const TransactionService();

  // Daftar kolom untuk daftar dan detail. `customers(...)` mengambil data
  // pelanggan, `payments(*)` mengambil semua pembayaran nota itu.
  static const _listColumns = '*, customers(nama), payments(*)';
  static const _detailColumns =
      '*, customers(nama, no_wa, alamat), transaction_items(*), payments(*)';

  /// Semua transaksi, terbaru dulu. Untuk layar Daftar dan Dashboard.
  Future<List<Transaction>> getTransactions() {
    return runSupabase(() async {
      final rows = await supabase
          .from('transactions')
          .select(_listColumns)
          .order('tanggal', ascending: false)
          .order('created_at', ascending: false);
      return rows.map(Transaction.fromMap).toList();
    });
  }

  /// Satu transaksi lengkap dengan item dan pembayarannya. Untuk layar Detail.
  Future<Transaction> getTransaction(String id) {
    return runSupabase(() async {
      final row = await supabase
          .from('transactions')
          .select(_detailColumns)
          .eq('id', id)
          .single();
      return Transaction.fromMap(row);
    });
  }

  /// Transaksi milik satu pelanggan. Untuk layar Detail Pelanggan.
  Future<List<Transaction>> getByCustomer(String customerId) {
    return runSupabase(() async {
      final rows = await supabase
          .from('transactions')
          .select(_listColumns)
          .eq('customer_id', customerId)
          .order('tanggal', ascending: false)
          .order('created_at', ascending: false);
      return rows.map(Transaction.fromMap).toList();
    });
  }

  /// Transaksi terbaru yang memuat satu produk. Untuk layar Detail Produk.
  Future<List<Transaction>> getByProduct(String productId, {int limit = 10}) {
    return runSupabase(() async {
      // Langkah 1: cari id nota yang memuat produk ini.
      final itemRows = await supabase
          .from('transaction_items')
          .select('transaction_id')
          .eq('product_id', productId);
      final ids = itemRows.map((r) => r['transaction_id'] as String).toList();
      if (ids.isEmpty) return <Transaction>[];

      // Langkah 2: ambil nota-nota itu.
      final rows = await supabase
          .from('transactions')
          .select(_listColumns)
          .inFilter('id', ids)
          .order('tanggal', ascending: false)
          .order('created_at', ascending: false)
          .limit(limit);
      return rows.map(Transaction.fromMap).toList();
    });
  }

  /// Membuat transaksi lewat fungsi database `create_transaction`.
  /// Di dalamnya: nomor nota otomatis, harga diambil dari produk, stok
  /// dikurangi, dan DP dicatat sebagai pembayaran pertama.
  /// Mengembalikan id transaksi baru.
  Future<String> createTransaction({
    required String customerId,
    required List<NewTransactionItem> items,
    DateTime? tanggal,
    DateTime? dueDate,
    int diskon = 0,
    int dp = 0,
    String? catatan,
  }) {
    if (items.isEmpty) {
      throw const ServiceException('Minimal 1 item');
    }
    return runSupabase(() async {
      final id = await supabase.rpc(
        'create_transaction',
        params: {
          'p_customer_id': customerId,
          'p_tanggal': tanggal == null ? null : _dateOnly(tanggal),
          'p_due_date': dueDate == null ? null : _dateOnly(dueDate),
          'p_diskon': diskon,
          'p_catatan': (catatan == null || catatan.trim().isEmpty)
              ? null
              : catatan.trim(),
          'p_dp': dp,
          'p_items': items.map((i) => i.toMap()).toList(),
        },
      );
      return id as String;
    });
  }

  /// Menghapus transaksi beserta item dan pembayarannya, dan stok
  /// produk dikembalikan (lewat fungsi database `delete_transaction`).
  Future<void> deleteTransaction(String id) {
    return runSupabase(() async {
      await supabase.rpc('delete_transaction', params: {'p_id': id});
    });
  }
}

/// Database menerima tanggal tanpa jam, contoh: 2026-11-28.
String _dateOnly(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}
