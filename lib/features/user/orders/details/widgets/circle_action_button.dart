import 'package:flutter/material.dart';

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const CircleActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: color.withValues(alpha: 0.1),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: size),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}