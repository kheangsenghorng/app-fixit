import 'package:fixit/features/user/profile/widgets/join_provider_sheet.dart';
import 'package:fixit/features/user/profile/widgets/profile_body_view.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom_header_bar.dart';
// Import your new Error widgets


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TEST VARIABLES
  bool hasError = false; // Change this to 'false' to test the Profile view
  bool isLoading = false;

  bool isUserProvider = true;

  void _retryFetch() {
    setState(() => isLoading = true);
    // Simulate a network delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        hasError = false; // Logic: After retry, show the data
      });
    });
  }

  @override

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    bool isLight = theme.colorScheme.surface.computeLuminance() > 0.5;
    Color headerTextColor = isLight ? const Color(0xFF002B5B) : Colors.white;

    return Scaffold(
      appBar: CustomHeaderBar(title: l10n.t('my_profile')),
      // Calling our new "Cut" class
      body: ProfileBodyView(
        isLoading: isLoading,
        hasError: hasError,
        errorMessage: "Connection failed. Please try again.",
        onRetry: _retryFetch,
        headerTextColor: headerTextColor,
        isProvider: isUserProvider,
        onJoinProvider: () => JoinProviderSheet(),
      ),
    );
  }
}