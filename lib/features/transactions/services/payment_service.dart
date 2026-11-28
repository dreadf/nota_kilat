import '../../../core/services/service_exception.dart';
import '../../../core/services/supabase_client.dart';
import '../models/payment.dart';

/// Mencatat dan menghapus pembayaran (DP atau pelunasan) pada sebuah nota.
class PaymentService {
  const PaymentService();

  /// Menambah pembayaran ke nota [transactionId].
  /// Ditolak kalau nominal 0 atau melebihi sisa tagihan.
  Future<void> addPayment({
    required String transactionId,
    required int nominal,
    DateTime? tanggal,
  }) {
    if (nominal <= 0) {
      throw const ServiceException('Nominal harus lebih dari 0');
    }
    return runSupabase(() async {
      final sisa = await _getSisa(transactionId);
      if (nominal > sisa) {
        throw ServiceException('Nominal melebihi sisa tagihan (sisa $sisa)');
      }
      final date = tanggal ?? DateTime.now();
      await supabase.from('payments').insert({
        'transaction_id': transactionId,
        'nominal': nominal,
        'tanggal': _dateOnly(date),
      });
    });
  }

  /// Menghapus satu pembayaran. Nota otomatis kembali ke status sebelumnya
  /// karena status dihitung dari daftar pembayaran.
  Future<void> deletePayment(String paymentId) {
    return runSupabase(() async {
      await supabase.from('payments').delete().eq('id', paymentId);
    });
  }

  /// Riwayat pembayaran satu nota, terbaru dulu.
  Future<List<Payment>> getPayments(String transactionId) {
    return runSupabase(() async {
      final rows = await supabase
          .from('payments')
          .select()
          .eq('transaction_id', transactionId)
          .order('tanggal', ascending: false)
          .order('created_at', ascending: false);
      return rows.map(Payment.fromMap).toList();
    });
  }

  /// Sisa tagihan = total nota dikurangi semua pembayaran.
  Future<int> _getSisa(String transactionId) async {
    final trx = await supabase
        .from('transactions')
        .select('total')
        .eq('id', transactionId)
        .single();
    final paid = await supabase
        .from('payments')
        .select('nominal')
        .eq('transaction_id', transactionId);
    final total = (trx['total'] as num).toInt();
    final dibayar = paid.fold<int>(
      0,
      (sum, row) => sum + (row['nominal'] as num).toInt(),
    );
    return total - dibayar;
  }
}

/// Database menerima tanggal tanpa jam, contoh: 2026-11-28.
String _dateOnly(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}
