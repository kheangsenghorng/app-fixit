import 'package:fixit/features/user/payment/payment_success/widgets/payment_receipt_details.dart';
import 'package:fixit/features/user/payment/payment_success/widgets/payment_success_title.dart';
import 'package:fixit/features/user/payment/payment_success/widgets/success_checkmark.dart';
import 'package:fixit/features/user/payment/payment_success/widgets/success_primary_button.dart';
import 'package:fixit/features/user/payment/payment_success/widgets/success_secondary_button.dart';
import 'package:flutter/material.dart';

class PaymentSuccessContent extends StatelessWidget {
  final String amount;
  final String serviceName;
  final VoidCallback onHomePressed;
  final VoidCallback onFeedbackPressed;

  const PaymentSuccessContent({
    super.key,
    required this.amount,
    required this.serviceName,
    required this.onHomePressed,
    required this.onFeedbackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clean, extracted success indicator
        const SuccessCheckmark(),

        const SizedBox(height: 32),

        // Using the extracted title widget
        const PaymentSuccessTitle(),
        const SizedBox(height: 12),

        // The "Cut" logic implemented:
        PaymentReceiptDetails(
          serviceName: serviceName,
          amount: amount,
        ),
        const SizedBox(height: 40),

        // Using the extracted primary button
        SuccessPrimaryButton(
          text: "Back to Home",
          onPressed: onHomePressed,
        ),

        const SizedBox(height: 12),
        // The final cut implemented:
        SuccessSecondaryButton(
          text: "Give Feedback",
          onPressed: onFeedbackPressed,
        ),
      ],
    );
  }
}