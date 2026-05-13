import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'schedule_booking_sheet.dart';

class FloatingBookingButton extends ConsumerWidget {
  final Map<String, dynamic> providerData;

  const FloatingBookingButton({
    super.key,
    required this.providerData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        scheduleBookingSheet(
          context,
          ref,
          providerData,
        );
      },
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withAlpha(200),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Schedule Booking",
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}