import 'package:flutter/material.dart';

class TimeGrid extends StatelessWidget {
  final String label;
  final List<String> times;           // e.g. ["09:00", "10:00", "11:00"]
  final String selectedTime;           // currently selected time
  final DateTime selectedDate;         // selected booking date
  final ValueChanged<String> onSelect;

  const TimeGrid({
    super.key,
    required this.label,
    required this.times,
    required this.selectedTime,
    required this.selectedDate,
    required this.onSelect,
  });

  bool _isPastTime(String time) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final selectedDay = DateUtils.dateOnly(selectedDate);

    // If selected day is before today → disable all
    if (selectedDay.isBefore(today)) {
      return true;
    }

    // If selected day is after today → enable all
    if (selectedDay.isAfter(today)) {
      return false;
    }

    // Selected day IS today → compare time
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final timeAsDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    return timeAsDate.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: times.map((time) {
            final isSelected = time == selectedTime;
            final isDisabled = _isPastTime(time);

            return GestureDetector(
              onTap: isDisabled ? null : () => onSelect(time),
              child: Opacity(
                opacity: isDisabled ? 0.4 : 1,
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : isDisabled
                            ? Colors.grey
                            : primary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
