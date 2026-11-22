import 'package:flutter/material.dart';

import '../utils/payment_status.dart';

/// Widget untuk menampilkan status pembayaran dalam bentuk badge.
class StatusBadge extends StatelessWidget {
  final PaymentStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    late final String label;
    late final Color backgroundColor;
    late final Color foregroundColor;

    switch (status) {
      case PaymentStatus.unpaid:
        label = 'Belum Dibayar';
        backgroundColor = theme.colorScheme.errorContainer;
        foregroundColor = theme.colorScheme.onErrorContainer;

      case PaymentStatus.partiallyPaid:
        label = 'Dibayar Sebagian';
        backgroundColor = theme.colorScheme.tertiaryContainer;
        foregroundColor = theme.colorScheme.onTertiaryContainer;

      case PaymentStatus.paid:
        label = 'Lunas';
        backgroundColor = theme.colorScheme.primaryContainer;
        foregroundColor = theme.colorScheme.onPrimaryContainer;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
