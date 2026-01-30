import 'package:flutter/material.dart'; // 🔥 Required for GlobalKey
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginFormProvider = StateProvider<LoginFormState>((ref) => const LoginFormState());

// This key will track the state of your login form
final loginFormKeyProvider = Provider((ref) => GlobalKey<FormState>());

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