import 'package:fixit/features/user/profile/appearance/widgets/appearance_body_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/provider/theme_provider.dart';
import '../../../../widgets/app_bar.dart';

// 1. Change to ConsumerStatefulWidget
class AppearanceScreen extends ConsumerStatefulWidget {
  const AppearanceScreen({super.key});

  @override
  ConsumerState<AppearanceScreen> createState() => _AppearanceScreenState();
}

// 2. Change to ConsumerState
class _AppearanceScreenState extends ConsumerState<AppearanceScreen> {
  String selectedIcon = "Modern";
  bool _isChangingIcon = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 3. Use ref.watch to get the global theme state
    final themeMode = ref.watch(themeNotifierProvider);
    final Color accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const OrderAppBar(title: 'APPEARANCE'),
      body: AppearanceBodyView(
        currentThemeMode: themeMode, // Pass the value from ref.watch
        selectedIcon: selectedIcon,
        accentColor: accentColor,
        isChangingIcon: _isChangingIcon,
        // 4. Use ref.read(...notifier) to trigger the change
        onThemeChanged: (mode) => ref.read(themeNotifierProvider.notifier).setThemeMode(mode),
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