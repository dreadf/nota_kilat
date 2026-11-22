import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

/// Layar pembuka. Memeriksa sesi login: ada sesi -> Dashboard, tidak ada -> Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _minDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future<void>.delayed(_minDuration);
    if (!mounted) return;
    final next =
        const AuthService().hasSession ? AppRoutes.dashboard : AppRoutes.login;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAuthGreen,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 34,
                color: kAuthGreen,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'NotaKilat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pesanan rapi, usaha pasti.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
