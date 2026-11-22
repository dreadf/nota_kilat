import 'package:intl/intl.dart';

/// Mengubah angka menjadi format mata uang Rupiah.
///
/// Contoh:
/// 500000 -> Rp500.000
String formatRupiah(num nominal) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  return formatter.format(nominal);
}

/// Mengubah DateTime menjadi format tanggal Indonesia.
///
/// Contoh:
/// 2026-11-21 -> 21 November 2026
String formatTanggal(DateTime tanggal) {
  const namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final hari = tanggal.day;
  final bulan = namaBulan[tanggal.month - 1];
  final tahun = tanggal.year;

  return '$hari $bulan $tahun';
}
