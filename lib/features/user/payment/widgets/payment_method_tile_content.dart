import 'package:fixit/features/user/payment/widgets/payment_checkmark.dart';
import 'package:fixit/features/user/payment/widgets/payment_method_icon.dart';
import 'package:fixit/features/user/payment/widgets/payment_method_name.dart';
import 'package:flutter/material.dart';

class PaymentMethodTileContent extends StatelessWidget {
  final String name;
  final bool isSelected;

  final String? icon;


  const PaymentMethodTileContent({
    super.key,
    required this.name,
    required this.isSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Branding
        PaymentMethodIcon(methodName:name, icon: icon),

        const SizedBox(width: 16),

        // 2. Identity
        PaymentMethodName(
          name: name,
          icon: icon,
          isSelected: isSelected,
        ),

        // 3. Selection Status
        PaymentCheckmark(isSelected: isSelected),
      ],
    );
  }
}