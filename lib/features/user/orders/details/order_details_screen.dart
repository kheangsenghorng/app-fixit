import 'package:fixit/features/user/orders/details/widgets/order_bottom_sheet.dart';
import 'package:fixit/features/user/orders/details/widgets/order_payment_summary.dart';
import 'package:fixit/features/user/orders/details/widgets/order_provider_card.dart';
import 'package:fixit/features/user/orders/details/widgets/order_status_card.dart';
import 'package:fixit/features/user/orders/details/widgets/service_details_card.dart';
import 'package:fixit/features/user/orders/details/widgets/tracking_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/app_bar.dart';
import '../data/provider/booking_by_booking_id_provider.dart';
import '../data/provider/booking_providers_by_booking_Id_provider.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final int bookingId;

  const OrderDetailsScreen({
    super.key,
    required this.bookingId,
  });

  Future<void> _reload(WidgetRef ref) async {
    ref.invalidate(bookingByBookingIdProvider(bookingId));
    ref.invalidate(bookingProvidersByBookingIdProvider(bookingId));

    await Future.wait([
      ref.read(bookingByBookingIdProvider(bookingId).future),
      ref.read(bookingProvidersByBookingIdProvider(bookingId).future),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bookingAsync = ref.watch(
      bookingByBookingIdProvider(bookingId),
    );

    final providersAsync = ref.watch(
      bookingProvidersByBookingIdProvider(bookingId),
    );

    final booking = bookingAsync.value?.data;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const OrderAppBar(title: "Track Booking"),
      body: RefreshIndicator(
        onRefresh: () => _reload(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              bookingAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        error.toString().replaceFirst('Exception: ', ''),
                        style: TextStyle(
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          ref.invalidate(
                            bookingByBookingIdProvider(bookingId),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                data: (response) {
                  final booking = response.data;

                  return OrderStatusCard(
                    bookingStatus: booking.bookingStatus ?? 'pending',
                    onViewMap: () => _showTrackingTimeline(
                      context,
                      booking.bookingStatus ?? 'pending',
                    ),
                  );
                },
              ),

              providersAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        error.toString().replaceFirst('Exception: ', ''),
                        style: TextStyle(
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          ref.invalidate(
                            bookingProvidersByBookingIdProvider(bookingId),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                data: (response) {
                  final providers = response.data;

                  if (providers.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No service providers assigned yet."),
                    );
                  }

                  return Column(
                    children: providers.map((provider) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OrderProviderCard(
                          bookingProvider: provider,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              bookingAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => const SizedBox.shrink(),
                data: (response) {
                  final booking = response.data;

                  return ServiceDetailsCard(
                    booking: booking,
                  );
                },
              ),

              if (booking != null)
                OrderPaymentSummary(
                  booking: booking,
                ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomSheet: OrderBottomSheet(
        buttonText: "Re-book Service",
        onPressed: () {
          ref.invalidate(bookingByBookingIdProvider(bookingId));
          ref.invalidate(bookingProvidersByBookingIdProvider(bookingId));
        },
      ),
    );
  }

  void _showTrackingTimeline(
      BuildContext context,
      String bookingStatus,
      ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) => TrackingSheetContent(
        bookingStatus: bookingStatus,
      ),
    );
  }
}