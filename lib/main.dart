import 'package:flutter/material.dart';

import 'core/services/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  await _checkSupabase();
  runApp(const MainApp());
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

// TODO: setelah PR app shell (#1) di-merge, ganti MainApp dengan NotaKilatApp
// dari app.dart.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
