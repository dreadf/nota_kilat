import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const greeting = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    color: AppColors.onPrimaryMuted,
  );

  static const businessName = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 33 / 22,
    letterSpacing: 0,
    color: Colors.white,
  );

  static const outstandingTotal = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 42 / 28,
    letterSpacing: -1.12,
    color: AppColors.textPrimary,
  );

  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 24 / 16,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const cardSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  static const transactionAmount = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    height: 20 / 14,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const paymentStatusLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 16.5 / 11,
    letterSpacing: 0,
  );

  static const navLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 15 / 10,
    letterSpacing: 0,
  );
}