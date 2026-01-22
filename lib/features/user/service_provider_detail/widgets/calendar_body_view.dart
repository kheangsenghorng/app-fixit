import 'package:flutter/material.dart';
import '../controller/calendar_controller.dart';
import 'calendar_header.dart';
import 'calendar_weekday_labels.dart';
import 'calendar_days_grid.dart';

class CalendarBodyView extends StatelessWidget {
  final CalendarController controller;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarBodyView({
    super.key,
    required this.controller,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. HEADER: Handles Month/Year and Navigation
        CalendarHeader(
          viewDate: controller.viewDate,
          onPreviousMonth: () => controller.changeMonth(-1),
          onNextMonth: () => controller.changeMonth(1),
        ),
        const SizedBox(height: 10),

        // 2. LABELS: Static "Sun" through "Sat"
        const CalendarWeekdayLabels(),
        const SizedBox(height: 10),

        // 3. GRID: Dynamic calculation of dates and selection
        CalendarDaysGrid(
          daysCount: controller.daysInMonth,
          offset: controller.firstDayOffset,
          // Checks controller to see if selection should be visible
          selectedDay: controller.isMonthMatches
              ? controller.selectedDate.day
              : null,
          onDayTap: (day) {
            controller.selectDate(day);
            onDateSelected(controller.selectedDate);
          },
        ),
      ],
    );
  }
}