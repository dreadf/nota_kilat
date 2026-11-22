import '../models/customer.dart';

/// Sumber data pelanggan. Untuk sementara memakai data dummy.
/// Saat Supabase siap, cukup ganti isi [getCustomers]; layar tidak perlu diubah.
class CustomerService {
  const CustomerService();

  Future<List<Customer>> getCustomers() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _dummyCustomers;
  }
}

const List<Customer> _dummyCustomers = [
  Customer(
    id: 'c1',
    nama: 'Nadia Putri',
    noWa: '081234567890',
    alamat: 'Jl. Melati No. 18, Bandung',
  ),
  Customer(
    id: 'c2',
    nama: 'Siti Rahma',
    noWa: '081298761234',
    alamat: 'Antapani, Bandung',
  ),
  Customer(
    id: 'c3',
    nama: 'Maya Lestari',
    noWa: '085712341234',
    alamat: 'Cimahi Utara',
  ),
  Customer(
    id: 'c4',
    nama: 'Rina Kurnia',
    noWa: '082112223333',
    alamat: 'Buah Batu, Bandung',
  ),
  Customer(id: 'c5', nama: 'Dewi Anggraini', noWa: '087811112222'),
  Customer(
    id: 'c6',
    nama: 'Fajar Nugroho',
    noWa: '081377778888',
    alamat: 'Jl. Dago Atas No. 5, Bandung',
  ),
];
