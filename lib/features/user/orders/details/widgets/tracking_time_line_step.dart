import 'package:flutter/material.dart';

class TrackingTimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isLast;

  const TrackingTimelineStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ផ្នែក Icon
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : theme.disabledColor,
              size: 24,
            ),
          ],
        ),
        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
              if (!isLast) const SizedBox(height: 25) else const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}