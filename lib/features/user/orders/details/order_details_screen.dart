import 'package:fixit/features/user/orders/details/widgets/order_bottom_sheet.dart';
import 'package:fixit/features/user/orders/details/widgets/order_payment_summary.dart';
import 'package:fixit/features/user/orders/details/widgets/order_provider_card.dart';
import 'package:fixit/features/user/orders/details/widgets/order_status_card.dart';
import 'package:fixit/features/user/orders/details/widgets/service_details_card.dart';
import 'package:fixit/features/user/orders/details/widgets/tracking_sheet_content.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/app_bar.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get colors from your lightTheme or darkTheme automatically
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const OrderAppBar(title: "Track Order"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Floating Status Card
            OrderStatusCard(
              onViewMap: () => _showTrackingTimeline(context),
            ),
            // 2. Provider Info Card
            const OrderProviderCard(),
            // 3. Service Details Card
            const ServiceDetailsCard(),
            // 4. Payment Receipt Card
            const OrderPaymentSummary(),

            const SizedBox(height: 120),
          ],
        )
      ),
      bottomSheet: OrderBottomSheet(
        buttonText: "Re-book Service",
        onPressed: () {
        },
      ),
    );
  }


  void _showTrackingTimeline(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const TrackingSheetContent(), // Clean and simple
    );
  }

}