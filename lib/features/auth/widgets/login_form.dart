import 'package:flutter/material.dart';

import 'custom_text_field.dart';



class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(
          hint: "Enter your email",
          icon: Icons.email_outlined,
        ),
        CustomTextField(
          hint: "Enter your password",
          icon: Icons.lock_outline,
          isPassword: true,
        ),
      ],
    );
  }
}