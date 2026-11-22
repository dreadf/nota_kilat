/// Pelanggan. Nama field mengikuti tabel `customers` di Supabase
/// (nama, no_wa, alamat).
class Customer {
  const Customer({
    required this.id,
    required this.nama,
    required this.noWa,
    this.alamat,
  });

  final String id;
  final String nama;
  final String noWa;
  final String? alamat;

  /// Inisial untuk avatar, maksimal dua huruf. Contoh: "Nadia Putri" -> "NP".
  String get inisial {
    final parts = nama.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    return parts.take(2).map((s) => s[0].toUpperCase()).join();
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as String,
      nama: map['nama'] as String,
      noWa: map['no_wa'] as String,
      alamat: map['alamat'] as String?,
    );
  }
}
