import 'package:flutter/material.dart';

/// Dialog konfirmasi sebelum menghapus data.
class ConfirmDeleteDialog {
  ConfirmDeleteDialog._();

  static Future<bool> show(
    BuildContext context, {
    String title = 'Hapus Data?',
    required String message,
    String cancelLabel = 'Batal',
    String confirmLabel = 'Hapus',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(cancelLabel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
