import 'package:flutter/material.dart';

class BookingStatusInfo {
  final String label;
  final double progress;
  final Color color;
  final IconData icon;
  final bool showMap;

  const BookingStatusInfo({
    required this.label,
    required this.progress,
    required this.color,
    required this.icon,
    this.showMap = false,
  });

  factory BookingStatusInfo.fromStatus(String status) {
    switch (status.trim().toLowerCase()) {
      case 'pending':
        return const BookingStatusInfo(
          label: 'Pending',
          progress: 0.15,
          color: Colors.orange,
          icon: Icons.schedule,
        );

      case 'confirmed':
        return const BookingStatusInfo(
          label: 'Confirmed',
          progress: 0.30,
          color: Colors.blue,
          icon: Icons.check_circle_outline,
        );

      case 'in_progress':
        return const BookingStatusInfo(
          label: 'Technician is on the way',
          progress: 0.60,
          color: Colors.indigo,
          icon: Icons.query_stats,
          showMap: true,
        );

      case 'awaiting_customer_confirmation':
        return const BookingStatusInfo(
          label: 'Awaiting your confirmation',
          progress: 0.80,
          color: Colors.purple,
          icon: Icons.verified_user_outlined,
        );

      case 'completed':
        return const BookingStatusInfo(
          label: 'Completed',
          progress: 1.0,
          color: Colors.green,
          icon: Icons.done_all,
        );

      case 'cancelled':
        return const BookingStatusInfo(
          label: 'Cancelled',
          progress: 0.0,
          color: Colors.red,
          icon: Icons.cancel_outlined,
        );

      case 'disputed':
        return const BookingStatusInfo(
          label: 'Disputed',
          progress: 0.50,
          color: Colors.deepOrange,
          icon: Icons.report_problem_outlined,
        );

      default:
        return const BookingStatusInfo(
          label: 'Unknown status',
          progress: 0.0,
          color: Colors.grey,
          icon: Icons.help_outline,
        );
    }
  }

  @override
  String toString() {
    return 'BookingStatusInfo(label: $label, progress: $progress, showMap: $showMap)';
  }
}