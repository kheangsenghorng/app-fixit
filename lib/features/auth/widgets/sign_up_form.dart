import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  static final nameController = TextEditingController();
  static final phoneController = TextEditingController();
  static final passwordController = TextEditingController();

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hint: "Full name",
          icon: Icons.person_outline,
          controller: SignUpForm.nameController,
        ),

        const SizedBox(height: 12),

        CustomTextField(
          hint: "Phone",
          icon: Icons.phone_outlined,
          controller: SignUpForm.phoneController,
        ),

        const SizedBox(height: 12),

        CustomTextField(
          hint: "Enter password",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: SignUpForm.passwordController,
        ),
      ],
    );
  }
}
