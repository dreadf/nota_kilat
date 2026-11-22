class AppValidators {
  AppValidators._();

  // Validasi input wajib diisi.
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    return null;
  }

  // Validasi format email.
  static String? validateEmail(String? value) {
    final required = validateRequired(value, fieldName: 'Email');

    if (required != null) return required;

    final email = value!.trim();
    final emailPattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

    if (!emailPattern.hasMatch(email)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Validasi password minimal 6 karakter.
  static String? validatePassword(String? value) {
    final required = validateRequired(value, fieldName: 'Password');

    if (required != null) return required;

    if (value!.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  // Validasi konfirmasi password.
  static String? validateConfirmPassword(String? value, String password) {
    final required = validateRequired(value, fieldName: 'Konfirmasi password');

    if (required != null) return required;

    if (value != password) {
      return 'Konfirmasi password tidak sama';
    }

    return null;
  }

  // Validasi nomor WhatsApp hanya angka.
  static String? validatePhone(String? value) {
    final required = validateRequired(value, fieldName: 'Nomor WhatsApp');

    if (required != null) return required;

    if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
      return 'Nomor WhatsApp hanya boleh berisi angka';
    }

    return null;
  }

  // Validasi harga harus berupa bilangan bulat lebih dari 0.
  static String? validatePrice(String? value) {
    final required = validateRequired(value, fieldName: 'Harga');

    if (required != null) return required;

    final price = int.tryParse(value!.trim(), radix: 10);

    if (price == null) {
      return 'Harga harus berupa bilangan bulat';
    }

    if (price <= 0) {
      return 'Harga harus lebih dari 0';
    }

    return null;
  }

  // Validasi stok bilangan bulat minimal 0.
  static String? validateStock(String? value) {
    final required = validateRequired(value, fieldName: 'Stok');

    if (required != null) return required;

    final stock = int.tryParse(value!.trim(), radix: 10);

    if (stock == null || stock < 0) {
      return 'Stok harus berupa bilangan bulat 0 atau lebih';
    }

    return null;
  }
}
