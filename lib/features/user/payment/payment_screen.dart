import 'package:fixit/features/user/payment/widgets/payment_method_list.dart';
import 'package:fixit/features/user/payment/widgets/payment_pay_button.dart';
import 'package:fixit/features/user/payment/widgets/section_label.dart';
import 'package:fixit/features/user/payment/payment_success/show_payment_success_dialog.dart';
import 'package:flutter/material.dart';
import '../../../widgets/app_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = "PayPal"; // Defaulting to PayPal to match screenshot

  final List<Map<String, String>> paymentMethods = [
    {"name": "KHQR", "icon": "assets/images/khqr_code.webp"},
    {"name": "Bank account", "icon": "assets/bank.png"},
    {"name": "Jazz cash", "icon": "assets/jazzcash.png"},
    {"name": "PayPal", "icon": "assets/paypal.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const OrderAppBar(title: "Payment"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const SectionLabel("Select Payment method"),
            const SizedBox(height: 24),
            // Cleanly extracted list widget
            PaymentMethodList(
              methods: paymentMethods,
              selectedMethod: selectedMethod,
              onSelect: (name) => setState(() => selectedMethod = name),
            ),
            // Reusable Bottom Button
            PaymentPayButton(
              onPressed: () => showPaymentSuccessDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}