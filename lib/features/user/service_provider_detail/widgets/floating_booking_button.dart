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

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () => scheduleBookingSheet(context, providerData),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withBlue(255),
              ],
            ),
          ),
          child: Center(
            child: Text(
              "Schedule Booking",
              style: theme.textTheme.labelLarge?.copyWith(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
