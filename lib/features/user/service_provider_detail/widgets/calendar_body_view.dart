import 'package:flutter/material.dart';

import '../data/controller/calendar_controller.dart';
import 'calendar_header.dart';
import 'calendar_weekday_labels.dart';
import 'calendar_days_grid.dart';

class CalendarBodyView extends StatelessWidget {
  final CalendarController controller;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime minDate;
  final DateTime maxDate;

  const CalendarBodyView({
    super.key,
    required this.controller,
    required this.onDateSelected,
    required this.minDate,
    required this.maxDate,
  });

  bool _isDateAllowed(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);

    return !cleanDate.isBefore(minDate) && !cleanDate.isAfter(maxDate);
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime(
      controller.viewDate.year,
      controller.viewDate.month,
      1,
    );

    final minMonth = DateTime(minDate.year, minDate.month, 1);
    final maxMonth = DateTime(maxDate.year, maxDate.month, 1);

    final canGoPrevious = currentMonth.isAfter(minMonth);
    final canGoNext = currentMonth.isBefore(maxMonth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarHeader(
          viewDate: controller.viewDate,
          onPreviousMonth: canGoPrevious
              ? () => controller.changeMonth(-1)
              : null,
          onNextMonth: canGoNext
              ? () => controller.changeMonth(1)
              : null,
        ),
        const SizedBox(height: 10),

        const CalendarWeekdayLabels(),
        const SizedBox(height: 10),

        CalendarDaysGrid(
          daysCount: controller.daysInMonth,
          offset: controller.firstDayOffset,
          selectedDay: controller.isMonthMatches
              ? controller.selectedDate.day
              : null,
          minDate: minDate,
          maxDate: maxDate,
          viewDate: controller.viewDate,
          onDayTap: (day) {
            final selected = DateTime(
              controller.viewDate.year,
              controller.viewDate.month,
              day,
            );

            if (!_isDateAllowed(selected)) return;

            controller.selectDate(day);
            onDateSelected(controller.selectedDate);
          },
        ),
      ],
    );
  }
}