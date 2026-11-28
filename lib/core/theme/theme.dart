import 'package:flutter/material.dart';

class MaterialTheme {
  const MaterialTheme(this.textTheme);

  final TextTheme textTheme;

  ThemeData light() {
    final colors = ColorScheme.fromSeed(
      seedColor: const Color(0xFF176B5B),
      primary: const Color(0xFF176B5B),
      surface: const Color(0xFFF8FAF9),
      surfaceContainer: Colors.white,
      onSurface: const Color(0xFF20342F),
      onSurfaceVariant: const Color(0xFF899691),
      secondaryContainer: const Color(0xFFE7F3EF),
      onSecondaryContainer: const Color(0xFF176B5B),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme
          .copyWith(
            labelSmall: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.5,
              letterSpacing: 0,
            ),
          )
          .apply(fontFamily: 'Plus Jakarta Sans'),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        centerTitle: false,
      ),
    );
  }
}