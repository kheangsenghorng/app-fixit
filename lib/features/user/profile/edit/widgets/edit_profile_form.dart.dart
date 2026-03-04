import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'phone_input_field.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const EditProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black;

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // PURE WHITE/BLACK BG
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(32),
        // NO BORDER, JUST SOFT SHADOW
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: "FULL NAME",
            hint: "Enter your name",
            controller: nameController,
            contentColor: contentColor,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            label: "EMAIL ADDRESS",
            hint: "Enter your email",
            controller: emailController,
            contentColor: contentColor,
          ),
          const SizedBox(height: 30),
          PhoneInputField(
            label: "PHONE NUMBER",
            hint: "012 345 678",
            controller: phoneController,
            contentColor: contentColor,
          ),
        ],
      ),
    );
  }
}