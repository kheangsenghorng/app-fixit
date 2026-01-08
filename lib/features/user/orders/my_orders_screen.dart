import 'dart:ui';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedTab = 2; // Default to Schedule

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Uses the deep blue in light mode / charcoal in dark mode
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildBlurredAppBar(context),
      body: Column(
        children: [
          // Spacer for Blurred AppBar
          SizedBox(height: MediaQuery.of(context).padding.top + 70),

          // 1. MODERN PILL TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 56,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                // Adaptive background for the tab container
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildTab(0, "Unpaid"),
                  _buildTab(1, "History"),
                  _buildTab(2, "Schedule"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. THE CONTENT SHEET
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface, // Uses 0xFF1E1E1E in dark, White in light
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTab == 0
                              ? "Pending Payments"
                              : selectedTab == 1
                              ? "Recent History"
                              : "Upcoming Services",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            // Ensure text is visible against surface
                            color: isDark ? Colors.white : colorScheme.primary,
                          ),
                        ),
                        Icon(Icons.tune_rounded, color: colorScheme.primary.withValues(alpha: 0.5)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ..._buildOrderList(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildBlurredAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AppBar(
            centerTitle: false,
            backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
            elevation: 0,
            title: Text(
              "My Orders",
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 26,
                // In Light mode, Scaffold is blue, so we want white text
                color: isDark ? Colors.white : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final theme = Theme.of(context);
    final isSelected = selectedTab == index;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white : theme.colorScheme.primary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? theme.colorScheme.primary : Colors.white)
                  : (isDark ? Colors.white60 : Colors.white70),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderList(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (selectedTab == 1) {
      return [
        OrderCard(
          icon: Icons.format_paint_rounded,
          amount: "600.00",
          date: "Dec 07, 2023",
          expertName: "Lucas Scott",
          activeColor: primaryColor,
        ),
      ];
    } else if (selectedTab == 2) {
      return [
        OrderCard(
          icon: Icons.cleaning_services_outlined,
          amount: "30/H",
          date: "Jan 04, 2024",
          time: "10:00 AM",
          expertName: "Emily Jani",
          activeColor: primaryColor,
          showCancelButton: true,
        ),
      ];
    }
    return [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text("No Orders", style: Theme.of(context).textTheme.bodyLarge),
        ),
      )
    ];
  }
}

class OrderCard extends StatelessWidget {
  final IconData icon;
  final String amount, date, expertName;
  final String? time;
  final Color activeColor;
  final bool showCancelButton;

  const OrderCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.date,
    required this.expertName,
    required this.activeColor,
    this.time,
    this.showCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Dark mode: use a slightly lighter grey than the surface.
        // Light mode: use a very faint grey or blue tint.
        color: isDark ? const Color(0xFF2A2A2A) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: activeColor, size: 24),
              ),
              Text(
                "\$$amount",
                style: TextStyle(
                  color: isDark ? Colors.white : activeColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: isDark ? Colors.white10 : Colors.black12, height: 1),
          const SizedBox(height: 15),

          _buildRow(theme, Icons.calendar_today_outlined, "Booking Date", date),
          if (time != null) _buildRow(theme, Icons.access_time, "Arrival Time", time!),
          _buildRow(theme, Icons.person_outline, "Expert name", expertName, isLink: true),

          if (showCancelButton) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: activeColor.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Cancel Booking",
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildRow(ThemeData theme, IconData icon, String label, String value, {bool isLink = false}) {
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isDark ? Colors.white38 : Colors.black38),
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isLink ? activeColor : (isDark ? Colors.white : Colors.black87),
              decoration: isLink ? TextDecoration.underline : null,
              decorationColor: activeColor,
            ),
          ),
        ],
      ),
    );
  }
}