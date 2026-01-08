import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this to your pubspec.yaml for date formatting

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
  late DateTime _viewDate;

  @override
  void initState() {
    super.initState();
    _viewDate = widget.selectedDate;
  }

  // --- Logic to calculate days in month ---
  int _daysInMonth(DateTime date) => DateTime(date.year, date.month + 1, 0).day;
  int _firstDayOffset(DateTime date) => DateTime(date.year, date.month, 1).weekday % 7;

  void _changeMonth(int offset) {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final daysCount = _daysInMonth(_viewDate);
    final offset = _firstDayOffset(_viewDate);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          // 1. HEADER: Month/Year Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_viewDate),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: primary),
                    onPressed: () => _changeMonth(-1),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: primary),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),

          // 2. Weekday Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // 1. Remove 'const' from here
            children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                .map((d) => Text(
              d,
              // 2. You can keep 'const' here for the style
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ))
                .toList(),
          ),
          const SizedBox(height: 10),

          // 3. Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            // Total items = offset (empty spaces) + actual days
            itemCount: daysCount + offset,
            itemBuilder: (context, index) {
              if (index < offset) return const SizedBox(); // Empty space before 1st of month
              final day = index - offset + 1;
              final isSelected = day == widget.selectedDate.day &&
                  _viewDate.month == widget.selectedDate.month &&
                  _viewDate.year == widget.selectedDate.year;

              return GestureDetector(
                onTap: () {
                  widget.onDateSelected(DateTime(_viewDate.year, _viewDate.month, day));
                },
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
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}