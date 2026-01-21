import 'package:fixit/features/user/payment/widgets/payment_method_icon.dart';
import 'package:fixit/features/user/payment/widgets/payment_title_text.dart';
import 'package:flutter/material.dart';

import 'glowy_checkmark.dart';
// Import your other custom classes here

class PaymentMethodRow extends StatelessWidget {
  final String title;
  final bool isSelected;

  const PaymentMethodRow({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. The Icon Class
        PaymentMethodIcon(methodName: title),
        const SizedBox(width: 15),
        // 2. The Text Class
        PaymentTitleText(
          title: title,
          isSelected: isSelected,
        ),

        // 3. The Checkmark Class
        GlowyCheckmark(isSelected: isSelected),
      ],
    );
  }
}