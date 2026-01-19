import 'package:fixit/features/user/orders/details/widgets/order_action_button.dart';
import 'package:fixit/features/user/orders/details/widgets/status_header.dart';
import 'package:fixit/features/user/orders/details/widgets/status_icon_box.dart';
import 'package:flutter/material.dart';



class OrderStatusRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String status;
  final String actionLabel;
  final VoidCallback onPressed;

  const OrderStatusRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.status,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatusIconBox(
          icon: icon,
          color: iconColor,
        ),
        const SizedBox(width: 15),
        StatusHeader(
          label: label,
          status: status,
        ),
        OrderActionButton(
          label: actionLabel,
          onPressed: onPressed,
        ),
      ],
    );
  }
}