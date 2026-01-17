import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'widgets/blurred_app_bar.dart';
import 'widgets/order_tab.dart';
import 'widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const BlurredAppBar(title: "My Orders"),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 70),

          // TAB SECTION
          Padding(
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
                  OrderTab(label: "Unpaid", isSelected: selectedTab == 0, onTap: () => setState(() => selectedTab = 0)),
                  OrderTab(label: "History", isSelected: selectedTab == 1, onTap: () => setState(() => selectedTab = 1)),
                  OrderTab(label: "Schedule", isSelected: selectedTab == 2, onTap: () => setState(() => selectedTab = 2)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CONTENT SECTION
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: _buildOrderList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      children: [
        Text(
          selectedTab == 0 ? "Pending Payments" : selectedTab == 1 ? "Recent History" : "Upcoming Services",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 25),

        if (selectedTab == 0)
          OrderCard(
            icon: Icons.shopping_cart_outlined,
            amount: "45.00",
            date: "Oct 12, 2024",
            expertName: "John Doe",
            activeColor: primaryColor,
            statusLabel: "Unpaid",
            statusColor: Colors.orange,
            actionButtonText: "Pay Now",
            onActionPressed: () {
              Navigator.pushNamed(context, AppRoutes.payment);
            },

          )
        else if (selectedTab == 1)
          OrderCard(
            icon: Icons.format_paint_rounded,
            amount: "600.00",
            date: "Dec 07, 2023",
            expertName: "Lucas Scott",
            activeColor: primaryColor,
            statusLabel: "Paid",
            statusColor: Colors.green,

          )
        else
          OrderCard(
            icon: Icons.cleaning_services_outlined,
            amount: "30/H",
            date: "Jan 04, 2024",
            time: "10:00 AM",
            expertName: "Emily Jani",
            activeColor: primaryColor,
            statusLabel: "Scheduled",
            statusColor: Colors.blue,
            actionButtonText: "Cancel Booking",
            onActionPressed: () {
              Navigator.pushNamed(context, AppRoutes.orderDetails);
            },
          ),
      ],
    );
  }
}