import 'package:flutter/material.dart';

class ReviewSummaryScreen extends StatelessWidget {
  const ReviewSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. EXTRACT DATA FROM NAVIGATION
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    final String address = args['address'] ?? "No address provided";
    final String date = args['date'] ?? "December 23, 2024";
    final String time = args['time'] ?? "10:00 AM";
    final String providerName = args['name'] ?? "Emily Jani";
    final String providerImage = args['image'] ?? 'assets/images/providers/img.png';

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Uses the background defined in your theme (Deep Blue for Light / Black for Dark)
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          // In Light mode, this is White (contrast with deep blue). In Dark, it's Primary.
          color: theme.brightness == Brightness.light ? Colors.white : colorScheme.primary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Summary",
          style: theme.textTheme.headlineMedium?.copyWith(
            // Ensure title is white when on the deep blue background of light mode
            color: theme.brightness == Brightness.light ? Colors.white : null,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Review Summary",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.brightness == Brightness.light ? Colors.white70 : null,
                      )
                  ),
                  const SizedBox(height: 15),

                  // 2. PROVIDER DETAILS CARD
                  _buildSummaryCard(
                    theme,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            providerName,
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            backgroundImage: AssetImage(providerImage),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      _buildRow(theme, "Type", "Plumber"),
                      _buildRow(theme, "Price", "\$20/H"),
                      _buildRow(theme, "Material", "Not Included"),
                      _buildRow(theme, "Traveling", "Free"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 3. BOOKING DETAILS CARD
                  _buildSummaryCard(
                    theme,
                    children: [
                      _buildRow(theme, "Address", address, isMultiLine: true),
                      const SizedBox(height: 10),
                      _buildRow(theme, "Booking date", date),
                      _buildRow(theme, "Booking Hours", time),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                              "\$20/H",
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. BOTTOM CONFIRM BUTTON
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: theme.elevatedButtonTheme.style,
                onPressed: () {
                  // Payment or Success logic
                },
                child: Text("Confirm", style: theme.textTheme.labelLarge?.copyWith(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildSummaryCard(ThemeData theme, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // White in Light / Dark Gray in Dark
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  theme.brightness == Brightness.light ? 0.1 : 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow(ThemeData theme, String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(width: 25),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                // Ensures value text is colored properly based on card surface
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}