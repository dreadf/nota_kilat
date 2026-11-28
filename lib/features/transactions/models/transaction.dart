import '../../../core/utils/payment_status.dart';
import 'payment.dart';
import 'transaction_item.dart';

/// Nota transaksi. Mengikuti tabel `transactions`.
///
/// Status, jumlah dibayar, dan sisa tidak disimpan di database; semuanya
/// dihitung dari [total] dan daftar [payments] lewat getter di bawah.
class Transaction {
  const Transaction({
    required this.id,
    required this.customerId,
    required this.nomor,
    required this.tanggal,
    required this.diskon,
    required this.total,
    this.dueDate,
    this.catatan,
    this.customerNama,
    this.customerNoWa,
    this.customerAlamat,
    this.items = const [],
    this.payments = const [],
  });

  final String id;
  final String customerId;
  final String nomor;
  final DateTime tanggal;
  final DateTime? dueDate;
  final int diskon;
  final int total;
  final String? catatan;

  // Data pelanggan, terisi kalau query menyertakan `customers(...)`.
  final String? customerNama;
  final String? customerNoWa;
  final String? customerAlamat;

  // Terisi kalau query menyertakan `transaction_items(*)` dan `payments(*)`.
  final List<TransactionItem> items;
  final List<Payment> payments;

  int get dibayar => PaymentStatusCalculator.calculatePaid(
    payments.map((p) => p.nominal).toList(),
  );

  int get sisa =>
      PaymentStatusCalculator.calculateRemaining(total: total, paid: dibayar);

  PaymentStatus get status =>
      PaymentStatusCalculator.calculateStatus(total: total, paid: dibayar);

  /// Total sebelum diskon.
  int get subtotal => total + diskon;

  factory Transaction.fromMap(Map<String, dynamic> map) {
    final customer = map['customers'] as Map<String, dynamic>?;
    final itemRows = (map['transaction_items'] as List?) ?? const [];
    final paymentRows = (map['payments'] as List?) ?? const [];
    final due = map['due_date'] as String?;

    return Transaction(
      id: map['id'] as String,
      customerId: map['customer_id'] as String,
      nomor: map['nomor'] as String,
      tanggal: DateTime.parse(map['tanggal'] as String),
      dueDate: due == null ? null : DateTime.parse(due),
      diskon: (map['diskon'] as num).toInt(),
      total: (map['total'] as num).toInt(),
      catatan: map['catatan'] as String?,
      customerNama: customer?['nama'] as String?,
      customerNoWa: customer?['no_wa'] as String?,
      customerAlamat: customer?['alamat'] as String?,
      items: [
        for (final row in itemRows)
          TransactionItem.fromMap(row as Map<String, dynamic>),
      ],
      payments: [
        for (final row in paymentRows)
          Payment.fromMap(row as Map<String, dynamic>),
      ],
    );
  }
}
