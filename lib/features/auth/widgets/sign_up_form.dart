import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(
          hint: "Full name",
          icon: Icons.person_outline,
        ),

        CustomTextField(
          hint: "Enter your email",
          icon: Icons.email_outlined,
        ),

        CustomTextField(
          hint: "Enter password",
          icon: Icons.lock_outline,
          isPassword: true,
        ),
      ],
    );
  }
}