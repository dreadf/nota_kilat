import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_client.dart';

/// Hasil pendaftaran. [needsEmailConfirmation] true jika Supabase meminta
/// akun dikonfirmasi lewat email dulu (belum ada sesi aktif).
class SignUpResult {
  const SignUpResult({required this.needsEmailConfirmation});

  final bool needsEmailConfirmation;
}

/// Error autentikasi dengan pesan Bahasa Indonesia yang siap ditampilkan.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Semua pemanggilan Supabase Auth untuk fitur auth. Layar tidak boleh
/// memanggil Supabase langsung.
class AuthService {
  const AuthService();

  /// True jika sudah ada sesi login yang tersimpan di perangkat.
  bool get hasSession => supabase.auth.currentSession != null;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } on AuthException catch (e) {
      throw AuthFailure(_translate(e));
    } catch (_) {
      throw const AuthFailure('Tidak dapat terhubung. Periksa koneksi internet.');
    }
  }

  /// Nama usaha dan nomor WhatsApp disimpan di user metadata sebagai identitas
  /// awal usaha (dipakai untuk kop nota, lihat fitur profile).
  Future<SignUpResult> signUp({
    required String namaUsaha,
    required String email,
    required String password,
    String? noWa,
  }) async {
    try {
      final res = await supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'nama_usaha': namaUsaha.trim(),
          if (noWa != null && noWa.trim().isNotEmpty) 'no_wa': noWa.trim(),
        },
      );
      return SignUpResult(needsEmailConfirmation: res.session == null);
    } on AuthException catch (e) {
      throw AuthFailure(_translate(e));
    } catch (_) {
      throw const AuthFailure('Tidak dapat terhubung. Periksa koneksi internet.');
    }
  }

  String _translate(AuthException e) {
    final code = e.code ?? '';
    final msg = e.message.toLowerCase();
    if (code == 'invalid_credentials' || msg.contains('invalid login')) {
      return 'Email atau password salah.';
    }
    if (code == 'email_not_confirmed' || msg.contains('not confirmed')) {
      return 'Email belum dikonfirmasi. Cek kotak masuk email Anda.';
    }
    if (code == 'user_already_exists' || msg.contains('already registered')) {
      return 'Email sudah terdaftar. Silakan masuk.';
    }
    if (code == 'weak_password') {
      return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
    }
    if (code == 'over_email_send_rate_limit' || msg.contains('rate limit')) {
      return 'Terlalu banyak percobaan. Coba lagi beberapa saat lagi.';
    }
    return 'Terjadi kesalahan: ${e.message}';
  }
}
