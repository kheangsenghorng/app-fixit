

import 'package:fixit/features/user/feedback/feedback_screen.dart';
import 'package:fixit/features/user/payment/payment_success/widgets/payment_success_content.dart';
import 'package:flutter/material.dart';

// Call this function to show the success dialog
void showPaymentSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must interact with buttons
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: PaymentSuccessContent(
        serviceName: "Plumber service",
        amount: "\$200.00",
        onHomePressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        onFeedbackPressed: () {
          Navigator.pop(context); // Close dialog
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          );
        },
      ),
    ),
  );
}