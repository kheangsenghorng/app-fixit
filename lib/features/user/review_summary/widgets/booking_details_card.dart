import 'package:flutter/material.dart';

class BookingDetailsCard extends StatelessWidget {
  final String address, date, time;

  const BookingDetailsCard({super.key, required this.address, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Booking Details", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _item(theme, Icons.location_on_outlined, "Address", address),
              const Divider(height: 30),
              _item(theme, Icons.calendar_today_outlined, "Date", date),
              const Divider(height: 30),
              _item(theme, Icons.access_time, "Time", time),
            ],
          ),
        ),
      ],
    );
  }

  Widget _item(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: theme.colorScheme.outline, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}