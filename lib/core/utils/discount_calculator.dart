/// Jenis diskon: potongan dalam Rupiah atau dalam persen.
enum DiscountType { rupiah, percent }

/// Menghitung dan memeriksa diskon pada form Buat Transaksi.
///
/// Aturannya sama dengan fungsi database `create_transaction`, jadi kesalahan
/// bisa ditampilkan lebih awal sebelum data dikirim.
class DiscountCalculator {
  DiscountCalculator._();

  /// Mengubah diskon menjadi Rupiah.
  ///
  /// Contoh: subtotal 200000 dengan diskon 10 persen -> 20000.
  /// Hasil persen dibulatkan ke Rupiah terdekat.
  static int toRupiah({
    required int subtotal,
    required DiscountType type,
    required int value,
  }) {
    if (type == DiscountType.rupiah) return value;
    return (subtotal * value / 100).round();
  }

  /// Mengembalikan pesan error, atau null kalau diskon valid.
  static String? validate({
    required int subtotal,
    required DiscountType type,
    required int value,
  }) {
    if (value < 0) {
      return 'Diskon tidak boleh negatif';
    }
    if (type == DiscountType.percent && value > 100) {
      return 'Diskon persen maksimal 100';
    }

    final rupiah = toRupiah(subtotal: subtotal, type: type, value: value);
    if (rupiah > subtotal) {
      return 'Diskon tidak boleh melebihi subtotal';
    }
    return null;
  }
}
