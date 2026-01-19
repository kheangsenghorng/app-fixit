import 'package:flutter/material.dart';

class PaymentSuccessTitle extends StatelessWidget {
  final String title;

  const PaymentSuccessTitle({
    super.key,
    this.title = "Payment Successful!",
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1A1A1A),
        letterSpacing: -0.5, // The "tightened" look for a modern feel
      ),
    );
  }
}