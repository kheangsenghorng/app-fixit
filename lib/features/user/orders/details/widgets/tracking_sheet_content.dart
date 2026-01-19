import 'package:fixit/features/user/orders/details/widgets/tracking_time_line_step.dart';
import 'package:flutter/material.dart';

class TrackingSheetContent extends StatelessWidget {
  const TrackingSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Order Status", style: theme.textTheme.headlineMedium),
          const SizedBox(height: 30),
          const TrackingTimelineStep(
            title: "Order Accepted",
            subtitle: "10:00 AM",
            isCompleted: true,
          ),
          const TrackingTimelineStep(
            title: "Technician Assigned",
            subtitle: "10:05 AM",
            isCompleted: true,
          ),
          const TrackingTimelineStep(
            title: "En Route",
            subtitle: "Heading to your location",
            isCompleted: false,
            isLast: true,
          ),
        ],
      ),
    );
  }
}