import 'package:flutter/material.dart';

class CalendarWeekdayLabels extends StatelessWidget {
  const CalendarWeekdayLabels({super.key});

  @override
  Widget build(BuildContext context) {
    const weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map((d) => Text(
        d,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ))
          .toList(),
    );
  }
}