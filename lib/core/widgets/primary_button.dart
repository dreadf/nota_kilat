import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Tombol utama hijau selebar layar. Dipakai untuk Simpan, Masuk, dan sejenisnya.
///
/// Saat [loading] true, tombol mati dan menampilkan spinner (mencegah
/// tombol ditekan dua kali saat data sedang dikirim).
///
/// Contoh:
/// ```dart
/// PrimaryButton(
///   label: 'Simpan Transaksi',
///   loading: _saving,
///   onPressed: _save,
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
