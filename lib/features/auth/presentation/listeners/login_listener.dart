import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';
import '../providers/auth_controller.dart';
import '../providers/login_form_provider.dart';

void listenLogin(BuildContext context, WidgetRef ref) {
  ref.listen(authControllerProvider, (prev, next) {
    next.whenOrNull(
      data: (auth) {
        if (auth != null) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      },
      error: (err, _) async {
        final msg = err.toString();

        if (msg.contains("Account not verified")) {
          final form = ref.read(loginFormProvider);

          try {
            await ref.read(authRepositoryProvider).sendOtp(form.login);

            if (context.mounted) {
              Navigator.pushNamed(
                context,
                '/otp',
                arguments: {
                  'phone': form.login,
                  'password': form.password,
                },
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Could not send OTP")),
              );
            }
          }
        }
      },
    );
  });
}
