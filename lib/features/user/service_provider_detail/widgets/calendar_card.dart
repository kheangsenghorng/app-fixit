import 'package:flutter/material.dart';
import '../controller/calendar_controller.dart';
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
    // Initialize the controller with the selected date
    _controller = CalendarController(selectedDate: widget.selectedDate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Use ListenableBuilder to rebuild only the calendar when the controller changes
    return// Inside your parent widget's build method
      ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return CalendarBodyView(
            controller: _controller,
            onDateSelected: (newDate) {
            },
          );
        },
      );
  }
}