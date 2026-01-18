import 'package:flutter/material.dart';

import 'order_action_button.dart';
import 'order_category_icon.dart';
import 'order_info_section.dart';
import 'order_price_header.dart';

class OrderCard extends StatelessWidget {
  final IconData icon;
  final String amount, date, expertName;
  final String? time;
  final Color activeColor;
  final String? statusLabel;
  final Color? statusColor;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.date,
    required this.expertName,
    required this.activeColor,
    this.time,
    this.statusLabel,
    this.statusColor,
    this.actionButtonText,
    this.onActionPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            // Inside OrderCard's build method
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrderCategoryIcon(
                  icon: icon,
                  activeColor: activeColor,
                ),
                OrderPriceHeader(
                  amount: amount,
                  statusLabel: statusLabel,
                  statusColor: statusColor,
                  activeColor: activeColor,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: isDark ? Colors.white10 : Colors.black12),
            const SizedBox(height: 15),
            OrderInfoSection(
              date: date,
              time: time,
              expertName: expertName,
              activeColor: activeColor,
            ),
            // Inside OrderCard Column
            if (actionButtonText != null)
              OrderActionButton(
                text: actionButtonText!,
                activeColor: activeColor,
                onPressed: onActionPressed,
              ),
          ],
        ),
      ),
    );
  }
}
