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

    // 1. Watch auth state
    final auth = ref.watch(authControllerProvider);

// 2. Only watch user when logged in
    final userAsync = auth.value == null ? null : ref.watch(userProvider);


    final isLight = theme.colorScheme.surface.computeLuminance() > 0.5;
    final headerTextColor = isLight ? const Color(0xFF002B5B) : Colors.white;

    return Scaffold(
      appBar: CustomHeaderBar(
        title: l10n.t('my_profile'),
        showBackButton: false,
      ),
      body: _buildBody(auth, userAsync, l10n, headerTextColor, context),
    );
  }

  Widget _buildBody(
      AsyncValue auth,
      AsyncValue? userAsync,
      AppLocalizations l10n,
      Color headerTextColor,
      BuildContext context
      ) {
    // 🔥 Case A: Auth itself is loading (App is checking if user is logged in)
    if (auth.isLoading && auth.value == null) {
      return const GeneralLoadingView();
    }

    // 🔥 Case B: Logged out
    if (auth.value == null) {
      return const SizedBox();
    }

    // 🔥 Case C: Logged in, handling User Profile data
    return userAsync!.when(
      // Use the new GeneralLoadingView here
      loading: () => GeneralLoadingView(
        message: l10n.t('loading_profile'), // "Loading your profile..."
      ),

      // Ignore errors as per your requirement
      error: (_, __) => const SizedBox(),

      data: (user) => ProfileBodyView(
        user: user,
        headerTextColor: headerTextColor,
        onJoinProvider: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const JoinProviderSheet(),
          );
        },
      ),
    );
  }
}