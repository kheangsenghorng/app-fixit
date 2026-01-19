import 'package:flutter/material.dart';
import 'order_price_row.dart';
import 'order_section_card.dart';

// --- 3. Payment Summary Section ---
class OrderPaymentSummary extends StatelessWidget {
  const OrderPaymentSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderSectionCard(
      title: "Payment Summary",
      child: Column(
        children: [
          OrderPriceRow(label: "Subtotal", price: "\$180.00"),
          OrderPriceRow(label: "Tax (5%)", price: "\$10.00"),
          OrderPriceRow(label: "Fees", price: "\$10.00"),
          const Divider(height: 30),
          OrderPriceRow(label: "Total Paid", price: "\$200.00", isTotal: true),
        ],
      ),
    );
  }
}