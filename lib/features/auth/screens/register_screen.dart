import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../auth_validators.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaUsaha = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _noWa = TextEditingController();
  final _auth = const AuthService();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _namaUsaha.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _noWa.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _auth.signUp(
        namaUsaha: _namaUsaha.text,
        email: _email.text,
        password: _password.text,
        noWa: _noWa.text,
      );
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (result.needsEmailConfirmation) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Akun dibuat. Konfirmasi email Anda, lalu masuk.',
            ),
          ),
        );
        navigator.pushReplacementNamed(AppRoutes.login);
      } else {
        navigator.pushReplacementNamed(AppRoutes.dashboard);
      }
    } on AuthFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthBrandHeader(),
                    const SizedBox(height: 28),
                    const AuthTitle(
                      title: 'Mulai kelola usahamu',
                      subtitle: 'Buat akun untuk mencatat pesanan dan tagihan.',
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      label: 'Nama usaha *',
                      controller: _namaUsaha,
                      hint: 'Nama tokomu',
                      enabled: !_loading,
                      validator: (v) => AuthValidators.required(v, 'Nama usaha'),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Email',
                      controller: _email,
                      hint: 'nama@email.com',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      enabled: !_loading,
                      validator: AuthValidators.email,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Password',
                      controller: _password,
                      hint: 'Minimal 6 karakter',
                      obscure: true,
                      enabled: !_loading,
                      validator: AuthValidators.password,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Konfirmasi password',
                      controller: _confirm,
                      hint: 'Ulangi password',
                      obscure: true,
                      enabled: !_loading,
                      validator: (v) =>
                          AuthValidators.confirmPassword(v, _password.text),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Nomor WhatsApp (opsional)',
                      controller: _noWa,
                      hint: '08xxxxxxxxxx',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      enabled: !_loading,
                      validator: AuthValidators.optionalPhone,
                      onSubmitted: _submit,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      AuthErrorBanner(message: _error!),
                    ],
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      label: 'Daftar Sekarang',
                      loading: _loading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 16),
                    AuthSwitchLink(
                      question: 'Sudah punya akun?',
                      action: 'Masuk',
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
