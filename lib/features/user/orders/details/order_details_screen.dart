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
                        textAlign: TextAlign.center,
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
                        textAlign: TextAlign.center,
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
      bottomSheet: booking == null
          ? null
          : OrderBottomSheet(
        buttonText: _getBottomButtonText(booking),
        onPressed: () {
          final bookingStatus =
              booking.bookingStatus?.toLowerCase() ?? '';
          final customerStatus =
              booking.customerStatus?.toLowerCase() ?? '';

          if (bookingStatus == 'completed') {
            Navigator.pushNamed(
              context,
              '/feedback',
              arguments: {
                'bookingId': booking.id,
                'serviceId': booking.serviceId ?? booking.service?.id,
              },
            );
            return;
          }

          if (bookingStatus == 'cancelled' ||
              bookingStatus == 'canceled' ||
              customerStatus == 'refunded') {
            final serviceId = booking.serviceId ?? booking.service?.id;

            if (serviceId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Service ID not found"),
                ),
              );
              return;
            }

            Navigator.pushNamed(
              context,
              '/provider-detail',
              arguments: serviceId,
            );
            return;
          }

          _showCancelBookingDialog(
            context: context,
            ref: ref,
            bookingId: booking.id,
          );
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

  String _getBottomButtonText(dynamic booking) {
    final bookingStatus = booking.bookingStatus?.toLowerCase() ?? '';
    final customerStatus = booking.customerStatus?.toLowerCase() ?? '';

    if (bookingStatus == 'completed') {
      return "Add Review Service";
    }

    if (bookingStatus == 'cancelled' ||
        bookingStatus == 'canceled' ||
        customerStatus == 'refunded') {
      return "Re-book Service";
    }

    return "Cancel Booking";
  }

  Future<void> _showCancelBookingDialog({
    required BuildContext context,
    required WidgetRef ref,
    required int bookingId,
  }) async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const _CancelBookingSheet();
      },
    );

    if (reason == null || reason.trim().isEmpty) return;

    await _handleCancellation(
      ref: ref,
      context: context,
      bookingId: bookingId,
      reason: reason,
    );
  }

  Future<void> _handleCancellation({
    required WidgetRef ref,
    required BuildContext context,
    required int bookingId,
    required String reason,
  }) async {
    try {
      debugPrint("Cancel booking id: $bookingId");
      debugPrint("Cancel reason: $reason");

      /*
      TODO: Call your real cancel booking API here.

      Example:

      await ref.read(cancelBookingProvider.notifier).cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );
      */

      ref.invalidate(bookingByBookingIdProvider(bookingId));
      ref.invalidate(bookingProvidersByBookingIdProvider(bookingId));

      await Future.wait([
        ref.read(bookingByBookingIdProvider(bookingId).future),
        ref.read(bookingProvidersByBookingIdProvider(bookingId).future),
      ]);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 12),
              Text("Booking cancelled successfully"),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _CancelBookingSheet extends StatefulWidget {
  const _CancelBookingSheet();

  @override
  State<_CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends State<_CancelBookingSheet> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _confirmCancel() {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter cancel reason"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pop(context, reason);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Cancel Booking",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "Please tell us why you want to cancel this booking.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: _reasonController,
                maxLines: 4,
                minLines: 3,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Write your reason here...",
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Keep Booking"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _confirmCancel,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Confirm Cancel"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}