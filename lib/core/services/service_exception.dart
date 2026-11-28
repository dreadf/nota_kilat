import 'package:supabase_flutter/supabase_flutter.dart';

/// Error dari service dengan pesan yang siap ditampilkan ke pengguna.
///
/// Pesan dari database (misalnya "Stok Kemeja tidak cukup (sisa 2)") sudah
/// berbahasa Indonesia, jadi layar cukup menampilkan `e.toString()`.
class ServiceException implements Exception {
  const ServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Menjalankan [action] dan mengubah error Supabase menjadi [ServiceException].
///
/// Contoh di sebuah service:
/// ```dart
/// return runSupabase(() async {
///   final rows = await supabase.from('products').select();
///   return rows;
/// });
/// ```
Future<T> runSupabase<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on PostgrestException catch (e) {
    // Error dari database atau fungsi RPC (contoh: stok tidak cukup).
    throw ServiceException(e.message);
  } on AuthException catch (e) {
    throw ServiceException(e.message);
  } catch (_) {
    // Biasanya tidak ada internet. Detail teknis tidak perlu dilihat pengguna.
    throw const ServiceException('Gagal terhubung. Periksa koneksi internet.');
  }
}
