import 'package:fixit/features/user/review_summary/widgets/price_summary_section.dart';
import 'package:fixit/features/user/review_summary/widgets/provider_profile_card.dart';
import 'package:fixit/features/user/review_summary/widgets/show_success_booking_dialog.dart';
import 'package:flutter/material.dart';

import 'widgets/booking_details_card.dart';


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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ProviderInfoCard(name: providerName, image: providerImage),
                  const SizedBox(height: 25),
                  BookingDetailsCard(address: address, date: dateText, time: timeText),
                  const SizedBox(height: 25),
                  const PriceSummaryCard(totalPrice: "20.00"),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildConfirmButton(context, theme, timeText),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: theme.primaryColor,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 16),
            color: theme.colorScheme.primary,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: Text("Summary", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildConfirmButton(BuildContext context, ThemeData theme, String time) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          onPressed: () => showSuccessBookingDialog(context, time: time),
          child: const Text("Confirm Booking", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}