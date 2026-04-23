import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_controller.dart';

import '../providers/login_form_provider.dart';
import '../../data/models/auth_model.dart';

ProviderSubscription<AsyncValue<AuthModel?>> listenLogin(
    BuildContext context,
    WidgetRef ref,
    ) {
  return ref.listenManual<AsyncValue<AuthModel?>>(
    authControllerProvider,
        (prev, next) {
      next.whenOrNull(
        data: (auth) {
          if (auth == null || !context.mounted) return;

          final form = ref.read(loginFormProvider);

          // OTP FLOW
          if (auth.isOtp) {
            final previousWasSameOtp =
                prev?.valueOrNull?.message == auth.message &&
                    prev?.valueOrNull?.login == auth.login &&
                    prev?.valueOrNull?.requestId == auth.requestId;

            if (!previousWasSameOtp) {
              Navigator.pushReplacementNamed(
                context,
                '/otp',
                arguments: {
                  'phone': auth.login ?? form.login,
                  'request_id': auth.requestId,
                  'channel': auth.channel,
                  'message': auth.message,
                },

              );
            }
            return;
          }

          // LOGIN SUCCESS
          if (auth.isLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
                  (route) => false,
            );
          }
        },
        error: (err, _) {
          if (!context.mounted) return;

          final msg = err.toString().replaceAll('Exception: ', '');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        },
      );
    },
  );
}