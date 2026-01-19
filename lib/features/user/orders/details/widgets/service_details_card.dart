import 'package:flutter/material.dart';

import 'order_info_detail_row.dart';
import 'order_section_card.dart';

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderSectionCard(
      title: "Order Details",
      child: Column(
        children: [
          OrderInfoDetailRow(
            icon: Icons.handyman_outlined,
            label: "Service",
            value: "Kitchen Pipe Repair",
          ),
          OrderInfoDetailRow(
            icon: Icons.calendar_today,
            label: "Schedule",
            value: "Dec 07, 2023 | 10:00 AM",
          ),
          OrderInfoDetailRow(
            icon: Icons.location_on_outlined,
            label: "Location",
            value: "123 Green Street, NY",
          ),
        ],
      ),
    );
  }
}