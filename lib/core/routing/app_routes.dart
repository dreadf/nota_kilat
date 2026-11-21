/// Centralized route names for NotaKilat.
///
/// Names here do not import feature screens, so each team member can implement
/// their feature independently before it is connected in [NotaKilatApp].
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  static const String dashboard = '/dashboard';

  static const String transactions = '/transactions';
  static const String createTransaction = '/transactions/create';
  static const String transactionDetail = '/transactions/detail';

  static const String customers = '/customers';
  static const String createCustomer = '/customers/create';
  static const String customerDetail = '/customers/detail';
  static const String editCustomer = '/customers/edit';

  static const String products = '/products';
  static const String createProduct = '/products/create';
  static const String productDetail = '/products/detail';
  static const String editProduct = '/products/edit';

  static const String profile = '/profile';

  /// Only the four main pages are tabs; the remaining pages are pushed on top.
  static MainTab? tabFor(String? route) {
    switch (route) {
      case dashboard:
        return MainTab.dashboard;
      case transactions:
        return MainTab.transactions;
      case customers:
        return MainTab.customers;
      case products:
        return MainTab.products;
      default:
        return null;
    }
  }

  static String titleFor(String? route) {
    switch (route) {
      case splash:
        return 'Splash';
      case login:
        return 'Login';
      case register:
        return 'Daftar Akun';
      case dashboard:
        return 'Dashboard';
      case transactions:
        return 'Transaksi';
      case createTransaction:
        return 'Buat Transaksi';
      case transactionDetail:
        return 'Detail Transaksi';
      case customers:
        return 'Pelanggan';
      case createCustomer:
        return 'Tambah Pelanggan';
      case customerDetail:
        return 'Detail Pelanggan';
      case editCustomer:
        return 'Edit Pelanggan';
      case products:
        return 'Produk';
      case createProduct:
        return 'Tambah Produk';
      case productDetail:
        return 'Detail Produk';
      case editProduct:
        return 'Edit Produk';
      case profile:
        return 'Profil Usaha';
      default:
        return 'Halaman';
    }
  }
}

enum MainTab { dashboard, transactions, customers, products }

extension MainTabInfo on MainTab {
  String get label => switch (this) {
    MainTab.dashboard => 'Dashboard',
    MainTab.transactions => 'Transaksi',
    MainTab.customers => 'Pelanggan',
    MainTab.products => 'Produk',
  };
}
