import 'package:flutter/material.dart';
import 'order_tab.dart'; // Ensure this points to your OrderTab component

class OrderTabSwitcher extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const OrderTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            OrderTab(
              label: "Unpaid",
              isSelected: selectedTab == 0,
              onTap: () => onTabChanged(0),
            ),
            OrderTab(
              label: "History",
              isSelected: selectedTab == 1,
              onTap: () => onTabChanged(1),
            ),
            OrderTab(
              label: "Schedule",
              isSelected: selectedTab == 2,
              onTap: () => onTabChanged(2),
            ),
          ],
        ),
      ),
    );
  }
}