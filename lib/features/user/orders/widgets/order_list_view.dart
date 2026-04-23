import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/app_routes.dart';
import '../data/model/user_service_bookings_response.dart';
import '../data/repository/payment_repository_provider.dart';
import '../details/order_details_screen.dart';
import 'order_card.dart';

class OrderListView extends ConsumerWidget {
  final int selectedTab;
  final int userId;

  const OrderListView({
    super.key,
    required this.selectedTab,
    required this.userId,
  });

  Future<void> _onRefresh(WidgetRef ref) async {
    await ref.refresh(paymentsHistoryProvider(userId).future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final contentColor = isDark ? Colors.white : Colors.black;

    final paymentsAsync = ref.watch(paymentsHistoryProvider(userId));

    return RefreshIndicator(
      onRefresh: () => _onRefresh(ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        children: [
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
          paymentsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Error: $error'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(paymentsHistoryProvider(userId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (response) => _buildActiveTabContent(
              context,
              primaryColor,
              response.data,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getSectionTitle() {
    switch (selectedTab) {
      case 0:
        return "Pending Payments";
      case 1:
        return "Recent History";
      default:
        return "Upcoming Services";
    }
  }

  Widget _buildActiveTabContent(
      BuildContext context,
      Color primaryColor,
      List<ServiceBooking> bookings,
      ) {
    List<ServiceBooking> filtered = [];

    if (selectedTab == 0) {
      filtered = bookings.where((b) {
        return b.payment.any((p) => (p.status?.toLowerCase() ?? '') != 'paid');
      }).toList();
    } else if (selectedTab == 1) {
      filtered = bookings.where((b) {
        return b.payment.any((p) => (p.status?.toLowerCase() ?? '') == 'paid');
      }).toList();
    } else {
      filtered = bookings.where((b) {
        return (b.bookingStatus?.toLowerCase() ?? '') == 'pending';
      }).toList();
    }

    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text("No orders found"),
        ),
      );
    }

    return Column(
      children: filtered.map((booking) {
        final Payment? payment =
        booking.payment.isNotEmpty ? booking.payment.first : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OrderCard(
            icon: _getIcon(selectedTab),
            amount: payment?.finalAmount ?? "0.00",
            date: booking.bookingDate ?? '',
            time: booking.bookingHours,
            expertName: booking.service?.name ?? 'Unknown Service',
            activeColor: primaryColor,
            statusLabel: _getStatusLabel(selectedTab, payment, booking),
            statusColor: _getStatusColor(selectedTab, payment, booking),
            actionButtonText: _getActionButtonText(selectedTab, payment, booking),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OrderDetailsScreen(),
              ),
            ),
            onActionPressed: _getActionButtonText(selectedTab, payment, booking) == null
                ? null
                : () {
              if (selectedTab == 0) {
                Navigator.pushNamed(context, '/payment');
              } else if (selectedTab == 2) {
                Navigator.pushNamed(context, AppRoutes.orderDetails);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  IconData _getIcon(int tab) {
    switch (tab) {
      case 0:
        return Icons.shopping_cart_outlined;
      case 1:
        return Icons.history;
      default:
        return Icons.cleaning_services_outlined;
    }
  }

  String _getStatusLabel(int tab, Payment? payment, ServiceBooking booking) {
    if (tab == 0) {
      return payment?.status?.toUpperCase() ?? "UNPAID";
    }

    if (tab == 1) {
      return payment?.status?.toUpperCase() ?? "PAID";
    }

    return booking.bookingStatus ?? "Scheduled";
  }

  Color _getStatusColor(int tab, Payment? payment, ServiceBooking booking) {
    final paymentStatus = payment?.status?.toLowerCase();

    if (tab == 0 || tab == 1) {
      if (paymentStatus == 'paid') return Colors.green;
      if (paymentStatus == 'pending') return Colors.orange;
      if (paymentStatus == 'failed') return Colors.red;
      return Colors.orange;
    }

    return Colors.blue;
  }

  String? _getActionButtonText(int tab, Payment? payment, ServiceBooking booking) {
    final paymentStatus = payment?.status?.toLowerCase();

    if (tab == 0) {
      return paymentStatus == 'paid' ? null : "Pay Now";
    }

    if (tab == 2) {
      return "Cancel Booking";
    }

    return null;
  }
}