import 'package:flutter/material.dart';

import '../../data/model/user_service_bookings_response.dart';
import 'order_price_row.dart';
import 'order_section_card.dart';

class OrderPaymentSummary extends StatelessWidget {
  final ServiceBooking booking;

  const OrderPaymentSummary({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final payment = booking.payment.isNotEmpty ? booking.payment.first : null;

    final originalAmount = payment?.originalAmount ?? '0.00';
    final discountAmount = payment?.discountAmount ?? '0.00';
    final finalAmount = payment?.finalAmount ?? '0.00';
    final method = payment?.method ?? 'N/A';
    final status = payment?.status ?? 'N/A';

    return OrderSectionCard(
      title: "Payment Summary",
      child: Column(
        children: [
          OrderPriceRow(
            label: "Subtotal",
            price: "\$$originalAmount",
          ),
          OrderPriceRow(
            label: "Discount",
            price: "-\$$discountAmount",
          ),
          OrderPriceRow(
            label: "Payment Method",
            price: method,
          ),
          OrderPriceRow(
            label: "Payment Status",
            price: status,
          ),
          const Divider(height: 30),
          OrderPriceRow(
            label: "Total Paid",
            price: "\$$finalAmount",
            isTotal: true,
          ),
        ],
      ),
    );
  }
}