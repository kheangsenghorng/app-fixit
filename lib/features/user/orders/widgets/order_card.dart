import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final IconData icon;
  final String amount, date, expertName;
  final String? time;
  final Color activeColor;
  final String? statusLabel;
  final Color? statusColor;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: activeColor, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$$amount", style: TextStyle(color: isDark ? Colors.white : activeColor, fontSize: 22, fontWeight: FontWeight.w900)),
                  if (statusLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (statusColor ?? Colors.grey).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(statusLabel!, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: isDark ? Colors.white10 : Colors.black12),
          const SizedBox(height: 15),
          _OrderInfoRow(icon: Icons.calendar_today_outlined, label: "Booking Date", value: date),
          if (time != null) _OrderInfoRow(icon: Icons.access_time, label: "Arrival Time", value: time!),
          _OrderInfoRow(icon: Icons.person_outline, label: "Expert name", value: expertName, isLink: true, activeColor: activeColor),

          if (actionButtonText != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: actionButtonText == "Pay Now" ? Colors.green : activeColor.withValues(alpha: 0.1),
                  foregroundColor: actionButtonText == "Pay Now" ? Colors.white : activeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(actionButtonText!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

// Internal private helper widget
class _OrderInfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool isLink;
  final Color? activeColor;

  const _OrderInfoRow({required this.icon, required this.label, required this.value, this.isLink = false, this.activeColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isDark ? Colors.white38 : Colors.black38),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isLink ? activeColor : (isDark ? Colors.white : Colors.black87),
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }
}