import 'package:flutter/material.dart';
import '../data/controller/calendar_controller.dart';
import 'calendar_body_view.dart';

class CalendarCard extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  late CalendarController _controller;
  late DateTime minDate;
  late DateTime maxDate;

  DateTime _onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();

    final today = _onlyDate(DateTime.now());

    minDate = today;
    maxDate = today.add(const Duration(days: 14));

    final selected = _onlyDate(widget.selectedDate);

    _controller = CalendarController(
      selectedDate: selected.isBefore(minDate) || selected.isAfter(maxDate)
          ? minDate
          : selected,
    );
  }

  @override
  void didUpdateWidget(covariant CalendarCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldDate = _onlyDate(oldWidget.selectedDate);
    final newDate = _onlyDate(widget.selectedDate);

    if (oldDate != newDate) {
      final fixedDate =
      newDate.isBefore(minDate) || newDate.isAfter(maxDate)
          ? minDate
          : newDate;

      _controller.selectedDate = fixedDate;
      _controller.viewDate = DateTime(fixedDate.year, fixedDate.month, 1);
      _controller.notifyListeners();
    }
  }

  bool _isDateAllowed(DateTime date) {
    final cleanDate = _onlyDate(date);
    return !cleanDate.isBefore(minDate) && !cleanDate.isAfter(maxDate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return CalendarBodyView(
          controller: _controller,
          minDate: minDate,
          maxDate: maxDate,
          onDateSelected: (newDate) {
            final cleanDate = _onlyDate(newDate);

            if (!_isDateAllowed(cleanDate)) return;

            widget.onDateSelected(cleanDate);
          },
        );
      },
    );
  }
}