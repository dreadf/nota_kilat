import 'package:flutter/material.dart';

import 'app.dart';
import 'core/routing/app_routes.dart';

/// Preview only: `flutter run -t lib/main_shell_preview.dart`
///
/// This avoids changing main.dart, which another member may use to initialize
/// Supabase. No database connection or authentication is required here.
void main() {
  runApp(const NotaKilatApp(initialRoute: AppRoutes.dashboard));
}
