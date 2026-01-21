import 'package:flutter/material.dart';

class PaymentReceiptDetails extends StatelessWidget {
  final String serviceName;
  final String amount;

  const PaymentReceiptDetails({
    super.key,
    required this.serviceName,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    const Color primaryBlue = Color(0xFF0056D2);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          color:textTheme.displayLarge?.color,
          height: 1.5,
        ),
        children: [
          const TextSpan(text: "Your payment for "),
          TextSpan(
            text: serviceName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textTheme.displaySmall?.color,
            ),
          ),
          const TextSpan(text: " of "),
          TextSpan(
            text: amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const TextSpan(text: "\nhas been processed successfully."),
        ],
      ),
    );
  }
}