import 'package:flutter/material.dart';

class CalendarDaysGrid extends StatelessWidget {
  final int daysCount;
  final int offset;
  final int? selectedDay;
  final Function(int) onDayTap;

  final DateTime minDate;
  final DateTime maxDate;
  final DateTime viewDate;

  const CalendarDaysGrid({
    super.key,
    required this.daysCount,
    required this.offset,
    this.selectedDay,
    required this.onDayTap,
    required this.minDate,
    required this.maxDate,
    required this.viewDate,
  });

  DateTime _onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isAllowed(DateTime date) {
    final cleanDate = _onlyDate(date);
    final cleanMinDate = _onlyDate(minDate);
    final cleanMaxDate = _onlyDate(maxDate);

    return !cleanDate.isBefore(cleanMinDate) &&
        !cleanDate.isAfter(cleanMaxDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: daysCount + offset,
      itemBuilder: (context, index) {
        if (index < offset) return const SizedBox();

        final day = index - offset + 1;

        final date = DateTime(
          viewDate.year,
          viewDate.month,
          day,
        );

        final isAllowed = _isAllowed(date);
        final isSelected = isAllowed && day == selectedDay;

        return GestureDetector(
          onTap: isAllowed ? () => onDayTap(day) : null,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$day",
                style: TextStyle(
                  color: !isAllowed
                      ? Colors.grey.shade400
                      : isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}