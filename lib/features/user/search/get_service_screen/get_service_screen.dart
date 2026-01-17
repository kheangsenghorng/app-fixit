import 'package:flutter/material.dart';

class GetServiceScreen extends StatelessWidget {
  final String? query;
  const GetServiceScreen({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    // 1. Access the theme data
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Uses the background color defined in your theme
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor:theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          query ?? "Service",
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        query ?? "Service",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.electrical_services,
                            size: 40, color: colorScheme.primary),
                      ),
                    ],
                  ),
                  Divider(height: 30, color: colorScheme.outlineVariant),
                  Row(
                    children: [
                      Icon(Icons.star, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 4),
                      Text("4.8 ",
                          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                      Text("(76)", style: theme.textTheme.bodySmall),
                      const Spacer(),
                      Text(
                        "\$20/Hour",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text("⏰", style: TextStyle(fontSize: 18)),
                      const Spacer(),
                      _timeBadge(context, "7:00AM"),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("To", style: TextStyle(color: Colors.grey)),
                      ),
                      _timeBadge(context, "10:00PM"),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "For what you need Electrician",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // 3. Service List
            _serviceItem(context, "Wiring Installation", Icons.cable, Colors.green.withValues(alpha: 0.1)),
            _serviceItem(context, "Electrical Repairs", Icons.build, Colors.blue.withValues(alpha: 0.1)),
            _serviceItem(context, "Indoor Lighting Installation", Icons.lightbulb, Colors.purple.withValues(alpha: 0.1)),
            _serviceItem(context, "Fixture Installation", Icons.fluorescent, Colors.pink.withValues(alpha: 0.1)),
            _serviceItem(context, "Electrical Panel Upgrades", Icons.developer_board, Colors.amber.withValues(alpha: 0.1)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _timeBadge(BuildContext context, String time) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _serviceItem(BuildContext context, String title, IconData icon, Color iconBg) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
          )
        ],
      ),
    );
  }
}