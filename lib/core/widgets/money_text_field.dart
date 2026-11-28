import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'app_text_field.dart';

/// Kolom nominal uang: hanya menerima angka dan menampilkan pemisah ribuan
/// (contoh: mengetik 1250000 tampil 1.250.000). Dipakai untuk DP, pembayaran,
/// diskon, dan harga.
///
/// Untuk membaca nilainya sebagai angka, pakai [MoneyTextField.parse]:
/// ```dart
/// final dp = MoneyTextField.parse(_dpController.text); // 1250000
/// ```
class MoneyTextField extends StatelessWidget {
  const MoneyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '0',
    this.validator,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction textInputAction;

  /// Mengubah teks "1.250.000" menjadi angka 1250000. Teks kosong menjadi 0.
  static int parse(String text) {
    return int.tryParse(text.replaceAll('.', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      controller: controller,
      hint: hint,
      validator: validator,
      enabled: enabled,
      textInputAction: textInputAction,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // buang semua selain angka
        LengthLimitingTextInputFormatter(12), // maksimal 12 digit
        _ThousandsFormatter(), // tambahkan titik ribuan
      ],
    );
  }
}

/// Menambahkan titik pemisah ribuan setiap kali isi kolom berubah.
class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final angka = int.parse(newValue.text);
    final teks = NumberFormat.decimalPattern('id_ID').format(angka);

    // Kursor selalu di ujung kanan, cukup untuk kolom nominal.
    return TextEditingValue(
      text: teks,
      selection: TextSelection.collapsed(offset: teks.length),
    );
  }
}
