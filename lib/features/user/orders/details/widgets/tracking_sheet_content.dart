import 'package:fixit/features/user/orders/details/widgets/tracking_time_line_step.dart';
import 'package:flutter/material.dart';

class TrackingSheetContent extends StatelessWidget {
  final String bookingStatus;

  const TrackingSheetContent({
    super.key,
    required this.bookingStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = TrackingStatusStep.fromBookingStatus(bookingStatus);

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Booking Status",
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 30),

          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;

            return TrackingTimelineStep(
              title: step.title,
              subtitle: step.subtitle,
              isCompleted: step.isCompleted,
              isLast: index == steps.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class TrackingStatusStep {
  final String title;
  final String subtitle;
  final bool isCompleted;

  const TrackingStatusStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  static List<TrackingStatusStep> fromBookingStatus(String status) {
    final normalizedStatus = status.trim().toLowerCase();

    bool isCompleted(String stepStatus) {
      const order = [
        'pending',
        'confirmed',
        'in_progress',
        'awaiting_customer_confirmation',
        'completed',
      ];

      final currentIndex = order.indexOf(normalizedStatus);
      final stepIndex = order.indexOf(stepStatus);

      if (currentIndex == -1 || stepIndex == -1) {
        return false;
      }

      return currentIndex >= stepIndex;
    }

    if (normalizedStatus == 'cancelled') {
      return const [
        TrackingStatusStep(
          title: 'Booking Cancelled',
          subtitle: 'This booking has been cancelled',
          isCompleted: true,
        ),
      ];
    }

    if (normalizedStatus == 'disputed') {
      return const [
        TrackingStatusStep(
          title: 'Booking Disputed',
          subtitle: 'This booking is under review',
          isCompleted: true,
        ),
      ];
    }

    return [
      TrackingStatusStep(
        title: 'Booking Pending',
        subtitle: 'Waiting for confirmation',
        isCompleted: isCompleted('pending'),
      ),
      TrackingStatusStep(
        title: 'Booking Confirmed',
        subtitle: 'Your booking has been accepted',
        isCompleted: isCompleted('confirmed'),
      ),
      TrackingStatusStep(
        title: 'Service In Progress',
        subtitle: 'Technician is working on your service',
        isCompleted: isCompleted('in_progress'),
      ),
      TrackingStatusStep(
        title: 'Awaiting Confirmation',
        subtitle: 'Please confirm when the service is done',
        isCompleted: isCompleted('awaiting_customer_confirmation'),
      ),
      TrackingStatusStep(
        title: 'Completed',
        subtitle: 'Service has been completed',
        isCompleted: isCompleted('completed'),
      ),
    ];
  }
}