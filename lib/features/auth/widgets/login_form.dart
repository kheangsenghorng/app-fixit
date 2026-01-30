import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../presentation/providers/login_form_provider.dart';
import 'custom_text_field.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(loginFormProvider);
    final formKey = ref.watch(loginFormKeyProvider); // Get the key

    return Form(
      key: formKey, // 🔥 VERY IMPORTANT: Connect the key to the form
      child: Column(
        children: [
          CustomTextField(
            hint: "Enter your email",
            icon: Icons.email_outlined,
            // Validation logic
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              return null;
            },
            onChanged: (v) => ref.read(loginFormProvider.notifier).state = form.copyWith(login: v),
          ),
          CustomTextField(
            hint: "Enter your password",
            icon: Icons.lock_outline,
            isPassword: true,
            // Validation logic
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            onChanged: (v) => ref.read(loginFormProvider.notifier).state = form.copyWith(password: v),
          ),
        ],
      ),
    );
  }
}
