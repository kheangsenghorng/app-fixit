import 'package:flutter/material.dart';
import 'widgets/booking_details_card.dart';
import 'widgets/price_summary_section.dart';
import 'widgets/provider_profile_card.dart';
import 'widgets/show_success_booking_dialog.dart';

class ReviewSummaryScreen extends StatelessWidget {
  const ReviewSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? rawArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args = rawArgs is Map<String, dynamic> ? rawArgs : {};

    final String address = args['address']?.toString() ?? "No address provided";
    final String providerName = args['name']?.toString() ?? "Emily Jani";
    final String providerImage = args['image']?.toString() ?? 'assets/images/providers/img.png';
    final String dateText = args['date']?.toString() ?? "Dec 23, 2024";
    final String timeText = args['time']?.toString() ?? "10:00 AM";

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor:colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Review Summary",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 150), // Extra bottom padding for footer
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderLabel(theme, "Professional Detail"),
                ProviderInfoCard(name: providerName, image: providerImage),
                const SizedBox(height: 32),

                _buildHeaderLabel(theme, "Schedule & Location"),
                BookingDetailsCard(address: address, date: dateText, time: timeText),
                const SizedBox(height: 32),

                _buildHeaderLabel(theme, "Payment Overview"),
                PriceSummaryCard(totalPrice: "20.00"),
              ],
            ),
          ),

          // Floating Action Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFloatingAction(context, theme, timeText),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLabel(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.w900,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildFloatingAction(BuildContext context, ThemeData theme, String time) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Estimated Total", style: theme.textTheme.bodyMedium),
              Text("\$20.00", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              onPressed: () => showSuccessBookingDialog(context, time: time),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Confirm Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}