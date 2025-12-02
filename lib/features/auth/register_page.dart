import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xevents/services/auth_service.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'customer';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Role:'),
            const SizedBox(width: 10),
            DropdownButton<String>(value: _role, items: const [
              DropdownMenuItem(value: 'customer', child: Text('Customer')),
              DropdownMenuItem(value: 'speaker', child: Text('Speaker')),
            ], onChanged: (v) => setState(() => _role = v ?? 'customer')),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading
                ? null
                : () async {
                    setState(() => _loading = true);
                    String? error;
                    try {
                      await ref.read(authServiceProvider).register(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text.trim(), _role);
                      if (!mounted) return;
                    } catch (e) {
                      error = e.toString();
                    }

                    if (!mounted) return;
                    if (error != null) {
                      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Register failed: $error')));
                    }
                    setState(() => _loading = false);
                  },
            child: _loading ? const CircularProgressIndicator() : const Text('Create account')),
        ]),
      ),
    );
  }
}
