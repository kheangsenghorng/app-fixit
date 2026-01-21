import 'package:flutter/material.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {

    // Assuming 't' is available via a provider or context helper

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}