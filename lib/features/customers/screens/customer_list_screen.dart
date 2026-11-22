import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../models/customer.dart';
import '../services/customer_service.dart';
import '../widgets/customer_card.dart';

const _green = Color(0xFF176B5B);
const _muted = Color(0xFF7B8985);

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({
    super.key,
    this.service = const CustomerService(),
  });

  final CustomerService service;

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late Future<List<Customer>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = widget.service.getCustomers();
  }

  void _reload() {
    setState(() => _future = widget.service.getCustomers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Pelanggan',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: FutureBuilder<List<Customer>>(
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
                  const Text('Gagal memuat pelanggan'),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _reload,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final all = snapshot.data ?? const <Customer>[];
          final q = _query.trim().toLowerCase();
          final shown = q.isEmpty
              ? all
              : all
                  .where((c) =>
                      c.nama.toLowerCase().contains(q) || c.noWa.contains(q))
                  .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau WhatsApp...',
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
                      '${shown.length} pelanggan',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.createCustomer,
                      ),
                      child: const Text(
                        '+ Tambah Pelanggan',
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
                              ? 'Belum ada pelanggan'
                              : 'Pelanggan tidak ditemukan',
                          style: const TextStyle(color: _muted),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: shown.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) => CustomerCard(
                          customer: shown[i],
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.customerDetail,
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
