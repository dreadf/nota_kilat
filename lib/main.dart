import 'package:flutter/material.dart';

import 'app.dart';
import 'core/routing/app_routes.dart';
import 'core/services/supabase_client.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  await _checkSupabase();
  runApp(
    NotaKilatApp(
      pageBuilders: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
      },
    ),
  );
}

/// SEMENTARA: cek koneksi, hasilnya tampil di console. Hapus setelah
/// layar-layar sungguhan tersambung. Tanpa login, RLS membuat hasilnya 0 baris
/// (itu normal dan berarti koneksi dan tabel beres).
Future<void> _checkSupabase() async {
  try {
    final rows = await supabase.from('products').select().limit(1);
    debugPrint('Supabase OK: tabel products terbaca (${rows.length} baris)');
  } catch (e) {
    debugPrint('Supabase GAGAL: $e');
  }
}
