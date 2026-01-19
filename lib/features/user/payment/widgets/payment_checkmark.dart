import 'package:flutter/material.dart';

class PaymentCheckmark extends StatelessWidget {
  final bool isSelected;

  const PaymentCheckmark({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0056D2);

    return Icon(
      Icons.check,
      // grey.shade100 makes it nearly invisible against white until selected
      color: isSelected ? primaryBlue : Colors.grey.shade100,
      size: 24,
    );
  }
}
