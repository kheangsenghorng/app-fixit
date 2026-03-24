import 'dart:ui'; // REQUIRED for ImageFilter
import 'package:fixit/features/auth/presentation/providers/auth_controller.dart';
import 'package:fixit/features/user/profile/providers/user_provider.dart';
import 'package:fixit/features/user/profile/widgets/join_provider_sheet.dart';
import 'package:fixit/features/user/profile/widgets/profile_body_view.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/general/general_loading_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final auth = ref.watch(authControllerProvider);
    final userAsync = ref.watch(userProvider);

    // 1. BLACK AND WHITE THEME LOGIC
    // Background: Pure black for dark, Pure white for light
    final scaffoldBg = isDark ? Colors.black : Colors.white;
    
    // Header Content (Text/Icons): White for dark mode, Black for light mode
    final contentColor = isDark ? Colors.white : Colors.black;

    // Header Glass Color
    final headerBg = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8) // Very dark grey glass
        : Colors.white.withValues(alpha: 0.8);

    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // 2. MAIN BODY CONTENT
          RefreshIndicator.adaptive(
            edgeOffset: 110,
            onRefresh: () async => await ref.read(userProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.only(top: 130, bottom: 100),
              child: _buildBody(auth, userAsync, l10n, theme, contentColor, context),
            ),
          ),

          // 3. FLOATING HEADER (BLACK & WHITE DESIGN)
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: headerBg,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black : Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TITLE IN BLACK/WHITE
                      Text(
                        l10n.t('my_profile'),
                        style: TextStyle(
                          color: contentColor, // Black or White text
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                      ),
                      
                      // SETTINGS ICON IN BLACK/WHITE
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.settings_outlined, 
                          color: contentColor, // Black or White icon
                          size: 22
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      AsyncValue auth,
      AsyncValue userAsync,
      AppLocalizations l10n,
      ThemeData theme,
      Color contentColor,
      BuildContext context,
      ) {
    // ✅ Handle auth error state explicitly — avoids the crash
    if (auth.hasError) return const SizedBox();

    if (auth.isLoading && auth.value == null) return const GeneralLoadingView();
    if (auth.value == null) return const SizedBox();

    final user = userAsync.value;
    final bool isProcessing = userAsync.isRefreshing || (userAsync.isLoading && user != null);

    if (user == null && userAsync.isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: GeneralLoadingView(message: l10n.t('loading_profile')),
      );
    }

    if (user == null && userAsync.hasError) {
      return const Center(child: Text("Error loading profile"));
    }

    return ProfileBodyView(
      user: user!,
      headerTextColor: contentColor,
      isLoading: isProcessing,
      onJoinProvider: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const JoinProviderSheet(),
        );
      },
    );
  }
}