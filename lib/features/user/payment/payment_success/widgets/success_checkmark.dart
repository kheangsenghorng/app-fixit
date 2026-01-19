import 'package:flutter/material.dart';

class SuccessCheckmark extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const SuccessCheckmark({
    super.key,
    this.primaryColor = const Color(0xFF0056D2),
    this.secondaryColor = const Color(0xFF007AFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 55,
      ),
    );
  }
}