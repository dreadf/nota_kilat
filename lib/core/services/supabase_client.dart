import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

/// Satu-satunya pintu ke Supabase. Semua `services/` memakai [supabase],
/// layar tidak boleh memanggilnya langsung.
///
/// Contoh di sebuah service:
/// ```dart
/// final rows = await supabase.from('products').select().order('nama');
/// ```
SupabaseClient get supabase => Supabase.instance.client;

/// Dipanggil sekali dari `main()` sebelum `runApp`.
Future<void> initSupabase() {
  return Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
}
