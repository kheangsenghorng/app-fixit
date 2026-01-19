import 'package:flutter/material.dart';
import 'order_glass_card.dart';
import 'order_status_progress.dart';
import 'order_status_row.dart';

// --- 1. Status Card Section ---
class OrderStatusCard extends StatelessWidget {
  final VoidCallback onViewMap;

  const OrderStatusCard({super.key, required this.onViewMap});

  @override
  Widget build(BuildContext context) {

    return OrderGlassCard(
      child: Column(
        children: [
          // The Row we refactored earlier
          OrderStatusRow(
            icon: Icons.query_stats,
            iconColor: Colors.blue,
            label: "Current Status",
            status: "Technician is on the way",
            actionLabel: "View Map",
            onPressed: onViewMap,
          ),
          // The Progress Bar we just extracted
          const OrderStatusProgress(progress: 0.7),
        ],
      ),
    );
  }
}


