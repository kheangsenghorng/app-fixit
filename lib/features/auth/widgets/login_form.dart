import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/providers/auth_controller.dart';
import '../presentation/providers/login_form_provider.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormProvider);
    final formKey = ref.watch(loginFormKeyProvider);
    final notifier = ref.read(loginFormNotifierProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: formState.login,
            decoration: const InputDecoration(
              labelText: 'Phone or Email',
            ),
            onChanged: (value) {
              notifier.setLogin(value);
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter phone or email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: formState.password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            onChanged: (value) {
              notifier.setPassword(value);
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}