import 'package:flutter/material.dart';

import 'core/routing/app_routes.dart';
import 'core/widgets/main_shell.dart';

/// App-wide configuration, routing and common navigation only.
///
/// Integrate screens implemented by teammates via [pageBuilders] and
/// [tabBuilders], without modifying anything inside their feature folders.
class NotaKilatApp extends StatelessWidget {
  const NotaKilatApp({
    super.key,
    this.initialRoute = AppRoutes.splash,
    this.pageBuilders = const {},
    this.tabBuilders = const {},
  });

  /// Normally Splash; the preview entrypoint opens Dashboard for testing.
  final String initialRoute;

  /// Builders for screens outside the bottom bar, such as login, profile,
  /// add/edit forms, and detail pages.
  final Map<String, WidgetBuilder> pageBuilders;

  /// Builders for the four bottom-navigation tabs.
  final Map<MainTab, WidgetBuilder> tabBuilders;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotaKilat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAF9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B5B),
          primary: const Color(0xFF176B5B),
          surface: const Color(0xFFF8FAF9),
          onSurface: const Color(0xFF20342F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAF9),
          foregroundColor: Color(0xFF20342F),
          centerTitle: false,
        ),
      ),
      // Use '/' as Navigator's root to avoid extra synthetic routes when a
      // named preview/start page (for example '/dashboard') is requested.
      initialRoute: Navigator.defaultRouteName,
      onGenerateRoute: (settings) {
        final route = settings.name == Navigator.defaultRouteName
            ? initialRoute
            : settings.name ?? initialRoute;
        final tab = AppRoutes.tabFor(route);
        if (tab != null) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => MainShell(
              initialTab: tab,
              tabBuilders: tabBuilders,
            ),
          );
        }
        final registeredPage = pageBuilders[route];
        return MaterialPageRoute<void>(
          settings: settings,
          builder: registeredPage ?? ((_) => _UnconnectedPage(route: route)),
        );
      },
    );
  }
}

/// An explicit placeholder (instead of inventing login/profile/CRUD screens).
class _UnconnectedPage extends StatelessWidget {
  const _UnconnectedPage({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    final title = AppRoutes.titleFor(route);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.layers_outlined,
                  size: 48, color: Color(0xFF176B5B)),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'Screen belum dihubungkan. Implementasinya tetap dikerjakan '
                'oleh anggota tim yang bertanggung jawab.',
                textAlign: TextAlign.center,
              ),
              if (route == AppRoutes.splash || route == AppRoutes.login) ...[
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.dashboard,
                  ),
                  child: const Text('Lihat pratinjau Dashboard'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
