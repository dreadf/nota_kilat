import 'package:flutter/material.dart';

import 'app.dart';
import 'core/routing/app_routes.dart';
import 'features/customers/screens/customer_list_screen.dart';
import 'features/products/screens/product_list_screen.dart';

/// Preview layar Daftar Produk dan Daftar Pelanggan (data dummy).
/// Jalankan: `flutter run -d chrome -t lib/main_list_preview.dart`
void main() {
  runApp(
    NotaKilatApp(
      initialRoute: AppRoutes.products,
      tabBuilders: {
        MainTab.products: (_) => const ProductListScreen(),
        MainTab.customers: (_) => const CustomerListScreen(),
      },
    ),
  );
}
