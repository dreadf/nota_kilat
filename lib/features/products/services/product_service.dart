import '../models/product.dart';

/// Sumber data produk. Untuk sementara memakai data dummy.
/// Saat Supabase siap, cukup ganti isi [getProducts]; layar tidak perlu diubah.
class ProductService {
  const ProductService();

  Future<List<Product>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _dummyProducts;
  }
}

const List<Product> _dummyProducts = [
  Product(id: 'p1', nama: 'Kemeja Linen Sage', harga: 189000, stok: 12),
  Product(id: 'p2', nama: 'Tunik Daily Cream', harga: 159000, stok: 8),
  Product(id: 'p3', nama: 'Pashmina Voal Premium', harga: 79000, stok: 24),
  Product(id: 'p4', nama: 'Outer Rajut Mocha', harga: 219000, stok: 0),
  Product(id: 'p5', nama: 'Celana Kulot Navy', harga: 145000, stok: 15),
  Product(id: 'p6', nama: 'Totebag Kanvas Polos', harga: 55000, stok: 40),
  Product(id: 'p7', nama: 'Kaos Oversize Hitam', harga: 99000, stok: 0),
  Product(id: 'p8', nama: 'Rok Plisket Dusty Pink', harga: 125000, stok: 6),
];
