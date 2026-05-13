import 'package:flutter/material.dart';

import '../../data/model/user_service_bookings_response.dart';
import 'order_info_detail_row.dart';
import 'order_section_card.dart';

class ServiceDetailsCard extends StatelessWidget {
  final ServiceBooking booking;

  const ServiceDetailsCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final serviceName = booking.service?.name ?? booking.service?.title ?? 'N/A';
    final packageTitle = booking.package?.title ?? 'N/A';
    final bookingDate = booking.bookingDate ?? 'N/A';
    final bookingHours = booking.bookingHours ?? '';
    final address = booking.address?.address ?? 'N/A';

    return OrderSectionCard(
      title: "Order Details",
      child: Column(
        children: [
          OrderInfoDetailRow(
            icon: Icons.handyman_outlined,
            label: "Service",
            value: serviceName,
          ),
          OrderInfoDetailRow(
            icon: Icons.inventory_2_outlined,
            label: "Package",
            value: packageTitle,
          ),
          OrderInfoDetailRow(
            icon: Icons.calendar_today,
            label: "Schedule",
            value: bookingHours.isNotEmpty
                ? "$bookingDate | $bookingHours"
                : bookingDate,
          ),
          OrderInfoDetailRow(
            icon: Icons.location_on_outlined,
            label: "Location",
            value: address,
          ),
        ],
      ),
    );
  }
}