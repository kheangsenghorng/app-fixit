import 'package:flutter/material.dart';

class StatusIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const StatusIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(

        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}