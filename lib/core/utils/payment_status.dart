/// Status pembayaran transaksi NotaKilat.
enum PaymentStatus { unpaid, partiallyPaid, paid }

/// Menghitung informasi pembayaran transaksi.
class PaymentStatusCalculator {
  PaymentStatusCalculator._();

  /// Menghitung total seluruh pembayaran.
  static int calculatePaid(List<int> payments) {
    return payments.fold(0, (total, payment) => total + payment);
  }

  /// Menghitung sisa tagihan.
  static int calculateRemaining({required int total, required int paid}) {
    return (total - paid).clamp(0, total);
  }

  /// Menentukan status pembayaran secara otomatis.
  static PaymentStatus calculateStatus({
    required int total,
    required int paid,
  }) {
    if (paid <= 0) {
      return PaymentStatus.unpaid;
    }

    if (paid >= total) {
      return PaymentStatus.paid;
    }

    return PaymentStatus.partiallyPaid;
  }
}
