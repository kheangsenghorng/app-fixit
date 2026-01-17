import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get colors from your lightTheme or darkTheme automatically
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          // Uses theme primary color for the back button
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Track Order",
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Floating Status Card
            _buildGlassCard(
              context,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildStatusIcon(context, Icons.query_stats, colorScheme.primary),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Current Status", style: textTheme.bodyMedium),
                            Text("Technician is on the way",
                                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showTrackingTimeline(context),
                        child: Text("View Map",
                            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      color: colorScheme.primary,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Provider Info Card
            _buildSectionCard(
              context,
              title: "Service Provider",
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lucas Scott", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text("Professional Plumber", style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  _circleIconButton(context, Icons.phone, Colors.green),
                  const SizedBox(width: 10),
                  _circleIconButton(context, Icons.chat_bubble, colorScheme.primary),
                ],
              ),
            ),

            // 3. Service Details Card
            _buildSectionCard(
              context,
              title: "Order Details",
              child: Column(
                children: [
                  _modernInfoRow(context, Icons.handyman_outlined, "Service", "Kitchen Pipe Repair"),
                  _modernInfoRow(context, Icons.calendar_today, "Schedule", "Dec 07, 2023 | 10:00 AM"),
                  _modernInfoRow(context, Icons.location_on_outlined, "Location", "123 Green Street, NY"),
                ],
              ),
            ),

            // 4. Payment Receipt Card
            _buildSectionCard(
              context,
              title: "Payment Summary",
              child: Column(
                children: [
                  _priceRow(context, "Subtotal", "\$180.00"),
                  _priceRow(context, "Tax (5%)", "\$10.00"),
                  _priceRow(context, "Fees", "\$10.00"),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Paid", style: textTheme.headlineMedium),
                      Text("\$200.00",
                          style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary, fontSize: 24)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: theme.elevatedButtonTheme.style?.copyWith(
            minimumSize: WidgetStateProperty.all(const Size(double.infinity, 56)),
          ),
          child: const Text("Re-book Service"),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS UPDATED FOR THEME ---

  Widget _buildGlassCard(BuildContext context, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _circleIconButton(BuildContext context, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.1)),
      child: IconButton(icon: Icon(icon, color: color, size: 20), onPressed: () {}),
    );
  }

  Widget _modernInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, String label, String price) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(price, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showTrackingTimeline(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Order Status", style: theme.textTheme.headlineMedium),
            const SizedBox(height: 20),
            _step(context, "Order Accepted", "10:00 AM", true),
            _step(context, "Technician Assigned", "10:05 AM", true),
            _step(context, "En Route", "Heading to your location", false),
          ],
        ),
      ),
    );
  }

  Widget _step(BuildContext context, String title, String sub, bool done) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.green : theme.disabledColor),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: done ? FontWeight.bold : FontWeight.normal)),
          Text(sub, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),
        ])
      ],
    );
  }
}