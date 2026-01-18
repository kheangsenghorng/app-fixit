import 'package:flutter/material.dart';

class OrderInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final Color? activeColor;

  const OrderInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Abstracting colors for cleaner code
    final iconColor = isDark ? Colors.white38 : Colors.black38;
    final labelStyle = TextStyle(
      color: isDark ? Colors.white54 : Colors.black54,
      fontSize: 14,
    );
    final valueStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: isLink ? activeColor : (isDark ? Colors.white : Colors.black87),
      decoration: isLink ? TextDecoration.underline : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 10),
          Text(label, style: labelStyle),

          // Spacer pushes the value to the right
          const Spacer(),

          // Flexible prevents "Yellow Tape" overflow if 'value' is too long
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}