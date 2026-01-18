import 'package:flutter/material.dart';

class OrderActionButton extends StatelessWidget {
  final String text;
  final Color activeColor;
  final VoidCallback? onPressed;

  const OrderActionButton({
    super.key,
    required this.text,
    required this.activeColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on the button text
    final isPayAction = text == "Pay Now";
    final backgroundColor = isPayAction
        ? Colors.green
        : activeColor.withValues(alpha: 0.1);
    final foregroundColor = isPayAction
        ? Colors.white
        : activeColor;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}