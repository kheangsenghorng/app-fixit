import 'dart:ui'; // REQUIRED for ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/provider/language_provider.dart';

class LanguagePickerSheet extends ConsumerWidget {
  const LanguagePickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLocale = ref.watch(languageNotifierProvider);

    // THEME COLORS (Matches Profile/Login UI)
    final contentColor = isDark ? Colors.white : Colors.black;
    final glassColor = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8) 
        : Colors.white.withValues(alpha: 0.9);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.only(
            left: 20, 
            right: 20, 
            top: 12, 
            bottom: MediaQuery.of(context).padding.bottom + 20
          ),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. DRAG HANDLE
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: contentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              // 2. TITLE
              Text(
                l10n.t('select_language'),
                style: TextStyle(
                  color: contentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              // 3. OPTIONS
              _LanguageOption(
                name: "English",
                code: "en",
                currentCode: currentLocale.languageCode,
                contentColor: contentColor,
                onTap: () {
                  ref.read(languageNotifierProvider.notifier).setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
              _LanguageOption(
                name: "ភាសាខ្មែរ",
                code: "km",
                currentCode: currentLocale.languageCode,
                contentColor: contentColor,
                onTap: () {
                  ref.read(languageNotifierProvider.notifier).setLocale(const Locale('km'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String name;
  final String code;
  final String currentCode;
  final Color contentColor;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.name,
    required this.code,
    required this.currentCode,
    required this.contentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentCode == code;
    final primaryBlue = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          // Subtle highlight for selected item
          color: isSelected 
              ? primaryBlue.withValues(alpha: 0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Language Name
            Text(
              name,
              style: TextStyle(
                color: contentColor,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Custom Selection Indicator
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primaryBlue, size: 22)
            else
              Icon(Icons.circle_outlined, color: contentColor.withValues(alpha: 0.2), size: 22),
          ],
        ),
      ),
    );
  }
}