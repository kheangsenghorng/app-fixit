import 'package:flutter/material.dart';

import 'order_info_row.dart';

class OrderInfoSection extends StatelessWidget {
  final String date;
  final String? time;
  final String expertName;
  final Color activeColor;

  const OrderInfoSection({
    super.key,
    required this.date,
    this.time,
    required this.expertName,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderInfoRow(
          icon: Icons.calendar_today_outlined,
          label: "Booking Date",
          value: date,
        ),
        if (time != null)
          OrderInfoRow(
            icon: Icons.access_time,
            label: "Arrival Time",
            value: time!,
          ),
        OrderInfoRow(
          icon: Icons.person_outline,
          label: "Expert name",
          value: expertName,
          isLink: true,
          activeColor: activeColor,
        ),
      ],
    );
  }
}