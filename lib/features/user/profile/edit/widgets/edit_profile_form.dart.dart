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
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: "Full Name",
            hint: "Enter name",
            controller: nameController,
          ),
          const Divider(height: 32, thickness: 0.5),
          CustomTextField(
            label: "Email Address",
            hint: "Enter email",
            controller: emailController,
          ),
          const Divider(height: 32, thickness: 0.5),
          PhoneInputField(
            label: "Phone Number",
            hint: "+92 300 1234567",
            controller: phoneController,
          ),
        ],
      ),
    );
  }
}