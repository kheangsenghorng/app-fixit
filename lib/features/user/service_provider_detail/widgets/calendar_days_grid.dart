import 'package:flutter/material.dart';

class CalendarDaysGrid extends StatelessWidget {
  final int daysCount;
  final int offset;
  final int? selectedDay;
  final Function(int) onDayTap;

  const CalendarDaysGrid({
    super.key,
    required this.daysCount,
    required this.offset,
    this.selectedDay,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemCount: daysCount + offset,
      itemBuilder: (context, index) {
        if (index < offset) return const SizedBox();

        final day = index - offset + 1;
        final isSelected = day == selectedDay;

        return GestureDetector(
          onTap: () => onDayTap(day),
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
    );
  }
}