import 'package:flutter/material.dart';

class CalendarController extends ChangeNotifier {
  DateTime selectedDate;
  DateTime viewDate;

  CalendarController({required this.selectedDate}) : viewDate = selectedDate;

  // --- Logic to calculate days in month ---
  int get daysInMonth => DateTime(viewDate.year, viewDate.month + 1, 0).day;
  int get firstDayOffset => DateTime(viewDate.year, viewDate.month, 1).weekday % 7;

  // --- Actions ---
  void changeMonth(int offset) {
    viewDate = DateTime(viewDate.year, viewDate.month + offset);
    notifyListeners(); // This triggers the UI to rebuild
  }

  void selectDate(int day) {
    selectedDate = DateTime(viewDate.year, viewDate.month, day);
    notifyListeners();
  }

  bool isDateSelected(int day) {
    return day == selectedDate.day &&
        viewDate.month == selectedDate.month &&
        viewDate.year == selectedDate.year;
  }
  // Inside CalendarController class

  bool get isMonthMatches {
    return viewDate.year == selectedDate.year &&
        viewDate.month == selectedDate.month;
  }
}