import 'package:flutter/material.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/theme.dart';
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
    final theme = MaterialTheme(ThemeData(useMaterial3: true).textTheme);

    return MaterialApp(
      title: 'NotaKilat',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.layers_outlined,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.titleLarge),
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