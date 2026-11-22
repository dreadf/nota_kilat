/// Produk yang dijual. Nama field mengikuti tabel `products` di Supabase
/// (nama, harga, stok) supaya nanti mudah disambungkan ke database.
class Product {
  const Product({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
  });

  final String id;
  final String nama;
  final int harga;
  final int stok;

  bool get habis => stok <= 0;

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      nama: map['nama'] as String,
      harga: (map['harga'] as num).toInt(),
      stok: (map['stok'] as num).toInt(),
    );
  }
}
