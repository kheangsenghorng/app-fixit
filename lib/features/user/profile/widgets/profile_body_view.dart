import 'package:fixit/features/user/profile/widgets/provider_account_switcher.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/error_screen/widgets/error_state_content.dart';
import 'profile_header.dart';
import 'profile_menu_section.dart';

class ProfileBodyView extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final bool isProvider;
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onJoinProvider;
  final Color headerTextColor;

  const ProfileBodyView({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.isProvider,
    required this.errorMessage,
    required this.onRetry,
    required this.onJoinProvider,
    required this.headerTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.colorScheme.surface,
      child: _buildStateContent(context),
    );
  }

  Widget _buildStateContent(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ErrorStateContent(errorMessage: errorMessage, onRetry: onRetry),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(), // Added for premium feel
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // 1. Header Section
          ProfileHeader(
            name: 'Mahrama',
            imageUrl: 'assets/images/providers/img.png',
            textColor: headerTextColor,
          ),

          const SizedBox(height: 10),

          // 2. The "New Style" Switcher Card
          // Placed at the top as a "Status Card"
          ProviderAccountSwitcher(
            isProvider: isProvider,
            onTap: () {
              if (isProvider) {
                Navigator.pushNamed(context, '/provider-dashboard');
              } else {
                onJoinProvider();
              }
            },
          ),

          const SizedBox(height: 10),

          // 3. Menu Section inside a subtle Card-like look
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: const ProfileMenuSection(),
          ),

          const SizedBox(height: 40), // Extra bottom padding
        ],
      ),
    );
  }
}