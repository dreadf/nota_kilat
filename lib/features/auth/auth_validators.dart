/// Validasi isian form Login dan Register.
///
/// Aturannya sama dengan `AppValidators` di core (PR feat/core). Setelah PR itu
/// di-merge, file ini bisa diganti dengan memanggil `AppValidators`.
abstract final class AuthValidators {
  static String? required(String? v, String field) =>
      (v == null || v.trim().isEmpty) ? '$field wajib diisi' : null;

  static String? email(String? v) {
    final r = required(v, 'Email');
    if (r != null) return r;
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(v!.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password(String? v) {
    final r = required(v, 'Password');
    if (r != null) return r;
    if (v!.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  static String? confirmPassword(String? v, String password) {
    final r = required(v, 'Konfirmasi password');
    if (r != null) return r;
    if (v != password) return 'Konfirmasi password tidak sama';
    return null;
  }

  /// Opsional: boleh kosong, tapi jika diisi harus angka saja.
  static String? optionalPhone(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    if (!RegExp(r'^[0-9]+$').hasMatch(v.trim())) {
      return 'Nomor WhatsApp hanya boleh berisi angka';
    }
    return null;
  }
}
