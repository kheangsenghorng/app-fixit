import 'package:flutter/material.dart';

class TimeGrid extends StatelessWidget {
  final String label;
  final List<String> times;
  final String selectedTime;
  final DateTime selectedDate;
  final ValueChanged<String> onSelect;

  const TimeGrid({
    super.key,
    required this.label,
    required this.times,
    required this.selectedTime,
    required this.selectedDate,
    required this.onSelect,
  });

  bool _isPastTime(String time, DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pickedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    // // debug
    // debugPrint('NOW: $now');
    // debugPrint('SELECTED DATE: $selectedDate');
    // debugPrint('TODAY ONLY: $today');
    // debugPrint('PICKED DAY ONLY: $pickedDay');
    // debugPrint('CHECK TIME: $time');

    // old date => disable all
    if (pickedDay.isBefore(today)) {
      return true;
    }

    // future date => enable all
    if (pickedDay.isAfter(today)) {
      return false;
    }

    // only today => compare hour/minute
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final slotDateTime = DateTime(
      pickedDay.year,
      pickedDay.month,
      pickedDay.day,
      hour,
      minute,
    );

    return !slotDateTime.isAfter(now);
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
            final isDisabled = _isPastTime(time, selectedDate);

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
                      color: isSelected ? primary : Colors.grey.shade300,
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