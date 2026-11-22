import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

const _green = Color(0xFF176B5B);
const _muted = Color(0xFF7B8985);

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, this.service = const ProductService()});

  final ProductService service;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = widget.service.getProducts();
  }

  void _reload() {
    setState(() => _future = widget.service.getProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Produk',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat produk'),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _reload,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final all = snapshot.data ?? const <Product>[];
          final q = _query.trim().toLowerCase();
          final shown = q.isEmpty
              ? all
              : all.where((p) => p.nama.toLowerCase().contains(q)).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari nama produk...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8EEEC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8EEEC)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${shown.length} produk',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.createProduct,
                      ),
                      child: const Text(
                        '+ Tambah Produk',
                        style: TextStyle(
                          color: _green,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: shown.isEmpty
                    ? Center(
                        child: Text(
                          all.isEmpty
                              ? 'Belum ada produk'
                              : 'Produk tidak ditemukan',
                          style: const TextStyle(color: _muted),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: shown.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) => ProductCard(
                          product: shown[i],
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: shown[i],
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
