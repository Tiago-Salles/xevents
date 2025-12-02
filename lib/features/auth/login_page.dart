import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xevents/services/auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      String? error;
                      try {
                        await ref.read(authServiceProvider).signIn(_emailCtrl.text.trim(), _passCtrl.text.trim());
                        // AuthGate will route
                        if (!mounted) return;
                      } catch (e) {
                        error = e.toString();
                      }

                      if (!mounted) return;
                      if (error != null) {
                        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Login failed: $error')));
                      }
                      setState(() => _loading = false);
                    },
              child: _loading ? const CircularProgressIndicator() : const Text('Sign in'),
            ),
            TextButton(onPressed: () => context.push('/register'), child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
