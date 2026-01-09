import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixit/core/provider/theme_provider.dart';

// Import your new components (assuming they are in the same directory or widgets folder)
import 'widgets/appearance_card.dart';
import 'widgets/appearance_option.dart';
import 'widgets/app_icon_option.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String selectedIcon = "Modern";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor:theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'APPEARANCE',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: "THEME SELECTION"),
            AppearanceCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppearanceOption(
                    title: "Light",
                    isSelected: themeProvider.themeMode == ThemeMode.light,
                    accentColor: accentColor,
                    brightness: Brightness.light,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                  ),
                  AppearanceOption(
                    title: "Dark",
                    isSelected: themeProvider.themeMode == ThemeMode.dark,
                    accentColor: accentColor,
                    brightness: Brightness.dark,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                  ),
                  AppearanceOption(
                    title: "System",
                    isSelected: themeProvider.themeMode == ThemeMode.system,
                    accentColor: accentColor,
                    isSystem: true,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const _SectionHeader(title: "APP ICON"),
            AppearanceCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppIconOption(
                    title: "Classic",
                    isSelected: selectedIcon == "Classic",
                    accentColor: accentColor,
                    bgColor: Colors.white,
                    borderColor: theme.colorScheme.primary,
                    onTap: () => setState(() => selectedIcon = "Classic"),
                  ),
                  AppIconOption(
                    title: "LifeStyle",
                    isSelected: selectedIcon == "LifeStyle",
                    accentColor: accentColor,
                    bgColor: theme.colorScheme.secondary,
                    borderColor: theme.colorScheme.secondary,
                    onTap: () => setState(() => selectedIcon = "LifeStyle"),
                  ),
                  AppIconOption(
                    title: "Modern",
                    isSelected: selectedIcon == "Modern",
                    accentColor: accentColor,
                    bgColor: const Color(0xFF121212),
                    borderColor: Colors.black,
                    onTap: () => setState(() => selectedIcon = "Modern"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}