import 'package:fixit/features/user/profile/appearance/widgets/appearance_body_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixit/core/provider/theme_provider.dart';

import '../../../../widgets/app_bar.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String selectedIcon = "Modern";
  bool _isChangingIcon = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final Color accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const OrderAppBar(title: 'APPEARANCE'),
      body: AppearanceBodyView(
        currentThemeMode: themeProvider.themeMode,
        selectedIcon: selectedIcon,
        accentColor: accentColor,
        isChangingIcon: _isChangingIcon,
        onThemeChanged: (mode) => themeProvider.setThemeMode(mode),
        onIconChanged: (iconName) async {
          setState(() {
            _isChangingIcon = true;
            selectedIcon = iconName;
          });
          // await AppIconService.changeAppIcon(iconName);
          if (mounted) setState(() => _isChangingIcon = false);
        },
      ),
    );
  }
}
