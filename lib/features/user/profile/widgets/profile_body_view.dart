import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';
import 'profile_header.dart';
import 'profile_menu_section.dart';
import 'provider_account_switcher.dart';

class ProfileBodyView extends StatelessWidget {
  final UserModel user;
  final VoidCallback onJoinProvider;
  final Color headerTextColor;
  final bool isLoading; // Triggers the Apple Blur

  const ProfileBodyView({
    super.key,
    required this.user,
    required this.onJoinProvider,
    required this.headerTextColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProvider = user.role == 'provider';

    return Stack(
      children: [
        // 1. CENTERED MAIN CONTENT
        Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.colorScheme.surface,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  // Forces content to take full screen height for centering
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Vertically
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Horizontally
                      children: [
                        // PROFILE HEADER
                        ProfileHeader(
                          name: user.name,
                          imageUrl: user.avatar ?? 'assets/images/providers/img.png',
                          textColor: headerTextColor,
                        ),

                        const SizedBox(height: 30),

                        // ACCOUNT SWITCHER (With Max Width for Tablet Support)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: ProviderAccountSwitcher(
                            isProvider: isProvider,
                            onTap: () {
                              if (isProvider) {
                                Navigator.pushNamed(context, '/provider-dashboard');
                              } else {
                                onJoinProvider();
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 25),

                        // MENU SECTION (Apple Style Card)
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 450),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: ProfileMenuSection(user: user),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 2. APPLE STYLE LOADING OVERLAY
        if (isLoading) _buildAppleOverlay(),
      ],
    );
  }

  Widget _buildAppleOverlay() {
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) => Opacity(opacity: value, child: child),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withValues(alpha: 0.05),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CupertinoActivityIndicator(radius: 15),
                    SizedBox(height: 15),
                    Text(
                      "Please wait...",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}