import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../details/order_details_screen.dart';
import 'order_card.dart';

class OrderListView extends StatelessWidget {
  final int selectedTab;

  const OrderListView({
    super.key,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final contentColor = isDark ? Colors.white : Colors.black;

    return ListView(
      physics: const BouncingScrollPhysics(),
      // Padding matches the "Floating Card" inner space
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      children: [
        // 1. SECTION HEADER (Matches Profile Name Style)
        Text(
          _getSectionTitle(),
          style: TextStyle(
            color: contentColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 25),

        // 2. CONTENT
        _buildActiveTabContent(context, primaryColor),
        
        // Extra bottom space
        const SizedBox(height: 20),
      ],
    );
  }

  String _getSectionTitle() {
    switch (selectedTab) {
      case 0: return "Pending Payments";
      case 1: return "Recent History";
      default: return "Upcoming Services";
    }
  }

  Widget _buildActiveTabContent(BuildContext context, Color primaryColor) {
    // Note: Ensure your OrderCard also follows the "No Border" and "Stadium Button" UI
    if (selectedTab == 0) {
      return OrderCard(
        icon: Icons.shopping_cart_outlined,
        amount: "45.00",
        date: "Oct 12, 2024",
        expertName: "John Doe",
        activeColor: primaryColor,
        statusLabel: "Unpaid",
        statusColor: Colors.orange,
        actionButtonText: "Pay Now",
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailsScreen())),
        onActionPressed: () => Navigator.pushNamed(context, '/payment'),
      );
    } else if (selectedTab == 1) {
      return OrderCard(
        icon: Icons.format_paint_rounded,
        amount: "600.00",
        date: "Dec 07, 2023",
        expertName: "Lucas Scott",
        activeColor: primaryColor,
        statusLabel: "Paid",
        statusColor: Colors.green,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailsScreen())),
      );
    } else {
      return OrderCard(
        icon: Icons.cleaning_services_outlined,
        amount: "30.00",
        date: "Jan 04, 2024",
        time: "10:00 AM",
        expertName: "Emily Jani",
        activeColor: primaryColor,
        statusLabel: "Scheduled",
        statusColor: Colors.blue,
        actionButtonText: "Cancel Booking",
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailsScreen())),
        onActionPressed: () => Navigator.pushNamed(context, AppRoutes.orderDetails),
      );
    }
  }
}