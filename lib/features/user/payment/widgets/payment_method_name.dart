import 'package:flutter/material.dart';

class PaymentMethodName extends StatelessWidget {
  final String name;
  final bool isSelected;
  final String? icon;


  const PaymentMethodName({
    super.key,
    required this.name,
    required this.isSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        name,
        // Prevents layout breaking if text is very long
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.black87 : Colors.black54,
        ),
      ),
    );
  }
}