import 'package:flutter/material.dart';
import '../../widgets/booking_status_info.dart';
import 'order_glass_card.dart';
import 'order_status_progress.dart';
import 'order_status_row.dart';

class OrderStatusCard extends StatelessWidget {
  final String bookingStatus;
  final VoidCallback onViewMap;

  const OrderStatusCard({
    super.key,
    required this.bookingStatus,
    required this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = BookingStatusInfo.fromStatus(bookingStatus);


    return OrderGlassCard(
      child: Column(
        children: [
          OrderStatusRow(
            icon: statusInfo.icon,
            iconColor: statusInfo.color,
            label: "Current Status",
            status: statusInfo.label,
            actionLabel: statusInfo.showMap ? "View Map" : null,
            onPressed: statusInfo.showMap ? onViewMap : null,
          ),
          OrderStatusProgress(
            progress: statusInfo.progress,
            color: statusInfo.color,
          ),
        ],
      ),
    );
  }
}

