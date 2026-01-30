import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your providers
import '../presentation/providers/auth_controller.dart';
import '../presentation/providers/login_form_provider.dart';

class LoginSubmitButton extends ConsumerWidget {
  const LoginSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final formData = ref.watch(loginFormProvider);
    final formKey = ref.watch(loginFormKeyProvider);

    // Primary color matching your theme
    const primaryBlue = Color(0xFF0056D2);

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryBlue.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Modern rounded corners
          ),
          // Disabled style
          disabledBackgroundColor: primaryBlue.withValues(alpha: 0.6),
        ),
        onPressed: authState.isLoading
            ? null
            : () {
          if (formKey.currentState?.validate() ?? false) {
            ref.read(authControllerProvider.notifier).login(
              formData.login,
              formData.password,
            );
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: authState.isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
              : const Text(
            "Sign In",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}