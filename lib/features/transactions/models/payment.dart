/// Satu pembayaran (DP atau pelunasan). Mengikuti tabel `payments`.
class Payment {
  const Payment({
    required this.id,
    required this.transactionId,
    required this.nominal,
    required this.tanggal,
  });

  final String id;
  final String transactionId;
  final int nominal;
  final DateTime tanggal;

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as String,
      transactionId: map['transaction_id'] as String,
      nominal: (map['nominal'] as num).toInt(),
      tanggal: DateTime.parse(map['tanggal'] as String),
    );
  }
}
