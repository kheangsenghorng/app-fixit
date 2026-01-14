import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0056D2);
    //final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.receipt_long, color: primaryBlue),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Status Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "COMPLETED",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  const Text("Order #FIX-7721", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Divider(height: 1),

            // 2. Technician Section
            _buildSection(
              title: "Service Provider",
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Lucas Scott", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Professional Plumber", style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline, color: primaryBlue),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.phone_in_talk_outlined, color: primaryBlue),
                  ),
                ],
              ),
            ),

            // 3. Service Info Section
            _buildSection(
              title: "Service Summary",
              child: Column(
                children: [
                  _infoRow(Icons.settings_outlined, "Service Type", "Kitchen Pipe Repair"),
                  _infoRow(Icons.calendar_today_outlined, "Date & Time", "Dec 07, 2023 | 10:00 AM"),
                  _infoRow(Icons.location_on_outlined, "Address", "123 Green Street, New York, NY"),
                ],
              ),
            ),

            // 4. Payment Breakdown (The Receipt)
            _buildSection(
              title: "Payment Summary",
              child: Column(
                children: [
                  _priceRow("Service Charge", "\$180.00"),
                  _priceRow("VAT (5%)", "\$10.00"),
                  _priceRow("Service Fee", "\$10.00"),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const Text("\$200.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 5),
                      Text("Paid via Easypaisa", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Re-book Service", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper to build sections with white backgrounds
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // Helper for info rows
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          )
        ],
      ),
    );
  }

  // Helper for price rows
  Widget _priceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}