import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_controller.dart';
import '../providers/login_form_provider.dart';

void listenLogin(BuildContext context, WidgetRef ref) {
  ref.listen(authControllerProvider, (prev, next) {
    next.whenOrNull(
      data: (auth) {
        if (auth == null) return;

        final form = ref.read(loginFormProvider);

        // 🔐 OTP FLOW (NEW)
        if (auth.requestId != null) {
          //  duplicate navigation
          if (prev?.value?.requestId != auth.requestId) {
            Navigator.pushReplacementNamed(
              context,
              '/otp',
              arguments: {
                'phone': form.login,
                'password': form.password,
                'request_id': auth.requestId,
              },
            );
          }
          return;
        }

        // ✅ LOGIN SUCCESS
        if (auth.token?.isNotEmpty == true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/main',
                (route) => false,
          );
          return;
        }
      },

      error: (err, _) {
        final msg = err.toString();

        // ❌ No more sendOtp here
        // Only show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg.replaceAll('Exception: ', ''))),
        );
      },
    );
  });
}