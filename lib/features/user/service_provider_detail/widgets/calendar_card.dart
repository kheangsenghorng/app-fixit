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

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      selectedDate: DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CalendarCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldDate = DateTime(
      oldWidget.selectedDate.year,
      oldWidget.selectedDate.month,
      oldWidget.selectedDate.day,
    );

    final newDate = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    if (oldDate != newDate) {
      _controller.selectedDate = newDate;
      _controller.viewDate = DateTime(newDate.year, newDate.month, 1);
      _controller.notifyListeners();
    }
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
          onDateSelected: (newDate) {
            widget.onDateSelected(
              DateTime(newDate.year, newDate.month, newDate.day),
            );
          },
        );
      },
    );
  }
}