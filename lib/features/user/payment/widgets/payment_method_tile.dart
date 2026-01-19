import 'package:fixit/features/user/payment/widgets/payment_method_icon.dart';
import 'package:flutter/material.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            // Reusing your PaymentMethodIcon
            PaymentMethodIcon(methodName: title),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? colorScheme.onSurface : Colors.grey.shade600,
                ),
              ),
            ),

            // Glowy/Animated Checkmark
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
              ),
              child: Icon(
                Icons.check_circle,
                size: 22,
                color: isSelected
                    ? colorScheme.primary
                    : Colors.grey.shade200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}