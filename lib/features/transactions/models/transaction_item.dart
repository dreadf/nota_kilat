/// Satu baris barang di nota. Mengikuti tabel `transaction_items`.
///
/// `namaProduk` dan `harga` adalah salinan saat transaksi dibuat, jadi nota
/// lama tidak berubah walau harga produk diubah atau produknya dihapus.
class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.transactionId,
    required this.namaProduk,
    required this.harga,
    required this.qty,
    required this.subtotal,
    this.productId,
  });

  final String id;
  final String transactionId;

  /// Kosong kalau produknya sudah dihapus.
  final String? productId;
  final String namaProduk;
  final int harga;
  final int qty;
  final int subtotal;

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'] as String,
      transactionId: map['transaction_id'] as String,
      productId: map['product_id'] as String?,
      namaProduk: map['nama_produk'] as String,
      harga: (map['harga'] as num).toInt(),
      qty: (map['qty'] as num).toInt(),
      subtotal: (map['subtotal'] as num).toInt(),
    );
  }
}

/// Item yang dipilih di form Buat Transaksi (belum disimpan).
/// Harga tidak dikirim: server mengambilnya sendiri dari tabel produk.
class NewTransactionItem {
  const NewTransactionItem({required this.productId, required this.qty});

  final String productId;
  final int qty;

  Map<String, dynamic> toMap() => {'product_id': productId, 'qty': qty};
}
