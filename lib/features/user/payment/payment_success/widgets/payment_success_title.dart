import 'package:flutter/material.dart';

class PaymentSuccessTitle extends StatelessWidget {
  final String title;

  const PaymentSuccessTitle({
    super.key,
    this.title = "Payment Successful!",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle( // Removed 'const' here
        fontSize: 24,
        fontWeight: FontWeight.w900,
        // Common choices:
        color: textTheme.displayLarge?.color,
        letterSpacing: -0.5,
      ),
    );
  }}