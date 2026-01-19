import 'package:flutter/material.dart';

class PaymentMethodIcon extends StatelessWidget {
  final String methodName;
  final String? icon;

  const PaymentMethodIcon({
    super.key,
    required this.methodName,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10), // Matching the smooth corners in your UI
      ),
      padding: const EdgeInsets.all(6), // Ensures the logo doesn't touch the edges
      child: icon != null && icon!.isNotEmpty
          ? Image.asset(
        icon!,
        fit: BoxFit.contain,
        // Fallback if the image path is broken
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(),
      )
          : _buildPlaceholderIcon(),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Icon(
      methodName == "Bank account" ? Icons.account_balance : Icons.payment,
      size: 20,
      color: Colors.grey.shade400,
    );
  }
}