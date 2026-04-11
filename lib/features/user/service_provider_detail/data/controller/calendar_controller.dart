import 'package:flutter/material.dart';

class CalendarController extends ChangeNotifier {
  DateTime selectedDate;
  DateTime viewDate;

  CalendarController({
    required this.selectedDate,
  }) : viewDate = DateTime(
    selectedDate.year,
    selectedDate.month,
    1,
  );

  int get daysInMonth => DateTime(viewDate.year, viewDate.month + 1, 0).day;

  int get firstDayOffset =>
      DateTime(viewDate.year, viewDate.month, 1).weekday % 7;

  void changeMonth(int offset) {
    viewDate = DateTime(viewDate.year, viewDate.month + offset, 1);
    notifyListeners();
  }

  void selectDate(int day) {
    selectedDate = DateTime(viewDate.year, viewDate.month, day);
    notifyListeners();
  }

  bool isDateSelected(int day) {
    return selectedDate.year == viewDate.year &&
        selectedDate.month == viewDate.month &&
        selectedDate.day == day;
  }

  bool get isMonthMatches {
    return viewDate.year == selectedDate.year &&
        viewDate.month == selectedDate.month;
  }
}