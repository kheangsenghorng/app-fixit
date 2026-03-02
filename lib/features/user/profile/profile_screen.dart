import 'package:fixit/features/auth/presentation/providers/auth_controller.dart';
import 'package:fixit/features/user/profile/providers/user_provider.dart';
import 'package:fixit/features/user/profile/widgets/join_provider_sheet.dart';
import 'package:fixit/features/user/profile/widgets/profile_body_view.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/custom_header_bar.dart';
import '../../../widgets/general/general_loading_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final auth = ref.watch(authControllerProvider);
    final userAsync = ref.watch(userProvider);

    final isLight = theme.colorScheme.surface.computeLuminance() > 0.5;
    final headerTextColor = isLight ? const Color(0xFF002B5B) : Colors.white;

    return Scaffold(
      appBar: CustomHeaderBar(
        title: l10n.t('my_profile'),
        showBackButton: false,
      ),
      body: RefreshIndicator.adaptive( // Adaptive makes it look like iOS
        onRefresh: () async {
          await ref.read(userProvider.notifier).refresh();
        },
        child: _buildBody(auth, userAsync, l10n, headerTextColor, context),
      ),
    );
  }

  Widget _buildBody(
      AsyncValue auth,
      AsyncValue userAsync,
      AppLocalizations l10n,
      Color headerTextColor,
      BuildContext context,
      ) {
    // 1. Check Auth Loading
    if (auth.isLoading && auth.value == null) {
      return const GeneralLoadingView();
    }

    if (auth.value == null) return const SizedBox();

    // 2. Optimized Data Loading Logic
    // We use .value to keep existing data on screen while refreshing/updating
    final user = userAsync.value;

    // Determine if we show the blur overlay (refreshing OR loading while data exists)
    final bool isProcessing = userAsync.isRefreshing || (userAsync.isLoading && user != null);

    // If we have no user data and we are loading, show full screen spinner
    if (user == null && userAsync.isLoading) {
      return GeneralLoadingView(message: l10n.t('loading_profile'));
    }

    // If we have no user data and an error
    if (user == null && userAsync.hasError) {
      return const Center(child: Text("Error loading profile"));
    }

    // 3. Main Centered View with Integrated Loading Overlay
    return ProfileBodyView(
      user: user!,
      headerTextColor: headerTextColor,
      isLoading: isProcessing, // This triggers the Apple Blur
      onJoinProvider: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent, // Allows for custom rounded sheet
          builder: (_) => const JoinProviderSheet(),
        );
      },
    );
  }
}