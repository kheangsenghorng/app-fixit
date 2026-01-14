import 'package:fixit/features/user/payment/widgets/show_payment_success_dialog.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Currently selected payment method
  String selectedMethod = "Easypaisa";

  final List<Map<String, String>> paymentMethods = [
    {"name": "Easypaisa", "icon": "assets/easypaisa.png"},
    {"name": "Bank account", "icon": "assets/bank.png"},
    {"name": "Jazz cash", "icon": "assets/jazzcash.png"},
    {"name": "PayPal", "icon": "assets/paypal.png"},
  ];

  // --- DIALOG FUNCTION ---

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0056D2);
    const Color lightBlueBackground = Color(0xFFE8F0F9);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Select Payment method",
              style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // List of Payment Options
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  bool isSelected = selectedMethod == method['name'];

                  return GestureDetector(
                    onTap: () => setState(() => selectedMethod = method['name']!),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      decoration: BoxDecoration(
                        color: isSelected ? lightBlueBackground : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? primaryBlue : Colors.grey.shade300, width: 1),
                      ),
                      child: Row(
                        children: [
                          _buildPaymentIcon(method['name']!), // Dynamic Icon helper
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              method['name']!,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
                            ),
                          ),
                          Icon(Icons.check, color: isSelected ? primaryBlue : Colors.grey.shade200, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Next Button -> TRIGGERS SUCCESS DIALOG
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => showPaymentSuccessDialog(context), // Triggering the dialog here
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Pay now", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper widget to handle icons
  Widget _buildPaymentIcon(String name) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
      child: Icon(
          name == "Bank account" ? Icons.account_balance : Icons.payment,
          size: 20,
          color: Colors.grey
      ),
    );
  }
}