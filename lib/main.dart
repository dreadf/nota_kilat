import 'package:flutter/material.dart';

import 'app.dart';
import 'core/routing/app_routes.dart';
import 'core/services/supabase_client.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/customers/screens/customer_list_screen.dart';
import 'features/products/screens/product_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  await _checkSupabase();
  runApp(
    NotaKilatApp(
      // Layar di luar bottom bar (login, detail, form).
      // Pemilik fitur: hapus tanda // di barisnya begitu layarnya selesai,
      // lalu tambahkan import-nya di atas.
      pageBuilders: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        // AppRoutes.profile: (_) => const ProfileScreen(),
        // AppRoutes.createProduct: (_) => const ProductFormScreen(),
        // AppRoutes.productDetail: (_) => const ProductDetailScreen(),
        // AppRoutes.editProduct: (_) => const ProductFormScreen(),
        // AppRoutes.createCustomer: (_) => const CustomerFormScreen(),
        // AppRoutes.customerDetail: (_) => const CustomerDetailScreen(),
        // AppRoutes.editCustomer: (_) => const CustomerFormScreen(),
        // AppRoutes.createTransaction: (_) => const CreateTransactionScreen(),
        // AppRoutes.transactionDetail: (_) => const TransactionDetailScreen(),
      },
      // Empat tab di bottom bar. Yang belum ada tetap tampil placeholder.
      tabBuilders: {
        // MainTab.dashboard: (_) => const DashboardScreen(),
        // MainTab.transactions: (_) => const TransactionListScreen(),
        MainTab.customers: (_) => const CustomerListScreen(),
        MainTab.products: (_) => const ProductListScreen(),
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
