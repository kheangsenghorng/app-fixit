import 'package:fixit/features/user/profile/help_support/widgets/help_app_bar.dart';
import 'package:fixit/features/user/profile/help_support/widgets/help_support_body_view.dart';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  final Color primaryBlue = const Color(0xFF0056D2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: HelpAppBar(
        primaryColor: primaryBlue,
        title: "Help & support",
      ),
      body: HelpSupportBodyView(), // Your new class widget
    );
  }
}