import 'package:flutter/material.dart';

import '../routing/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// The common bottom navigation used by the four primary NotaKilat features.
///
/// Screens from other members are provided through [tabBuilders]. Nothing in
/// this file imports or modifies their feature folders.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.initialTab = MainTab.dashboard,
    this.tabBuilders = const {},
  });

  final MainTab initialTab;
  final Map<MainTab, WidgetBuilder> tabBuilders;

  /// Switch tabs without pushing another MainShell onto the navigation stack.
  /// Returns false when called outside a MainShell.
  static bool switchTo(BuildContext context, MainTab tab) {
    final shell = context.findAncestorStateOfType<MainShellState>();
    if (shell == null) return false;
    shell.selectTab(tab);
    return true;
  }

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  late MainTab _selectedTab;
  final Set<MainTab> _visitedTabs = {};

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _visitedTabs.add(_selectedTab);
  }

  @override
  void didUpdateWidget(covariant MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      selectTab(widget.initialTab);
    }
  }

  void selectTab(MainTab tab) {
    if (_selectedTab == tab) return;
    setState(() {
      _selectedTab = tab;
      _visitedTabs.add(tab);
    });
  }

  Widget _screenFor(MainTab tab) {
    // A feature page is only created after its tab is visited. This prevents
    // unused features from loading data when Dashboard first opens.
    if (!_visitedTabs.contains(tab)) return const SizedBox.shrink();
    final builder = widget.tabBuilders[tab];
    if (builder != null) return builder(context);
    return _UnconnectedTab(tab: tab);
  }

  @override
  Widget build(BuildContext context) {
    final index = MainTab.values.indexOf(_selectedTab);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: index,
        children: [for (final tab in MainTab.values) _screenFor(tab)],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primarySurface,
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected ? AppColors.primary : AppColors.navInactive,
              );
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return AppTextStyles.navLabel.copyWith(
                color: selected ? AppColors.primary : AppColors.navInactive,
              );
            }),
          ),
          child: NavigationBar(
            height: 76,
            selectedIndex: index,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (selected) {
              selectTab(MainTab.values[selected]);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long_rounded),
                label: 'Transaksi',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people_rounded),
                label: 'Pelanggan',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
                label: 'Produk',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Temporary navigation-only placeholder. NOT a replacement for another
/// member's actual dashboard / transaction / customer / product screens.
class _UnconnectedTab extends StatelessWidget {
  const _UnconnectedTab({required this.tab});

  final MainTab tab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(tab.label)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppColors.primary,
                size: 46,
              ),
              const SizedBox(height: 16),
              Text('Halaman ${tab.label}',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'Tampilan fitur ini akan dihubungkan dari modul anggota tim.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
