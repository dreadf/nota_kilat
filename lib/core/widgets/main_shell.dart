import 'package:flutter/material.dart';

import '../routing/app_routes.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.initialTab = MainTab.dashboard,
    this.tabBuilders = const {},
  });

  final MainTab initialTab;
  final Map<MainTab, WidgetBuilder> tabBuilders;

  /// Switches tabs without adding another MainShell to the navigation stack.
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
    // Build each screen after its tab is first visited.
    if (!_visitedTabs.contains(tab)) return const SizedBox.shrink();

    final builder = widget.tabBuilders[tab];
    if (builder != null) return builder(context);

    return _UnconnectedTab(tab: tab);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final index = MainTab.values.indexOf(_selectedTab);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [for (final tab in MainTab.values) _screenFor(tab)],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: colors.surfaceContainer,
            indicatorColor: colors.secondaryContainer,
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected
                    ? colors.onSecondaryContainer
                    : colors.onSurfaceVariant,
              );
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return theme.textTheme.labelSmall?.copyWith(
                color: selected
                    ? colors.onSecondaryContainer
                    : colors.onSurfaceVariant,
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

class _UnconnectedTab extends StatelessWidget {
  const _UnconnectedTab({required this.tab});

  final MainTab tab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tab.label)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.layers_outlined,
                size: 46,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Halaman ${tab.label}',
                style: theme.textTheme.titleLarge,
              ),
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