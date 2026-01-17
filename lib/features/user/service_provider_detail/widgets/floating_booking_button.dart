import 'package:flutter/material.dart';
import 'schedule_booking_sheet.dart';

class FloatingBookingButton extends StatelessWidget {
  final Map<String, dynamic> providerData;

  const FloatingBookingButton({
    super.key,
    required this.providerData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Remove the Positioned widget from here
    return GestureDetector(
      onTap: () => scheduleBookingSheet(context, providerData),
      child: Container(
        height: 62, // Slightly taller for a more premium feel
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // More rounded to match the "New Style"
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withAlpha(200), // Updated from .withBlue for better theme compatibility
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
              color: Colors.white, // Ensure visibility on gradient
            ),
          ),
        ),
      ),
    );
  }
}