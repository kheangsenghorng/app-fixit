import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginFormProvider =
StateProvider<LoginFormState>((ref) => const LoginFormState());

final loginFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});

class LoginFormState {
  final String login;
  final String password;

  const LoginFormState({
    this.login = '',
    this.password = '',
  });

  LoginFormState copyWith({
    String? login,
    String? password,
  }) {
    return LoginFormState(
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

final loginFormNotifierProvider =
Provider<LoginFormNotifier>((ref) => LoginFormNotifier(ref));

class LoginFormNotifier {
  final Ref ref;

  LoginFormNotifier(this.ref);

  void setLogin(String value) {
    ref.read(loginFormProvider.notifier).state =
        ref.read(loginFormProvider).copyWith(login: value);
  }

  void setPassword(String value) {
    ref.read(loginFormProvider.notifier).state =
        ref.read(loginFormProvider).copyWith(password: value);
  }

  void clear() {
    ref.read(loginFormProvider.notifier).state = const LoginFormState();
  }
}