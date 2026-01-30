import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/provider/theme_provider.dart';

class ThemeModeSwitcher extends ConsumerWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String getModeName(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system:
          return "System Default";
        case ThemeMode.light:
          return "Light Mode";
        case ThemeMode.dark:
          return "Dark Mode";
      }
    }

    IconData getModeIcon(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system:
          return Icons.settings_brightness;
        case ThemeMode.light:
          return Icons.light_mode;
        case ThemeMode.dark:
          return Icons.dark_mode;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color:
            isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showThemePicker(context, ref),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            getModeIcon(themeMode),
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          "Appearance",
          style:
          theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          getModeName(themeMode),
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final currentMode = ref.watch(themeNotifierProvider);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Theme",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _themeOption(
                context,
                ref,
                "System Default",
                Icons.settings_brightness,
                ThemeMode.system,
                currentMode,
              ),
              _themeOption(
                context,
                ref,
                "Light Mode",
                Icons.light_mode,
                ThemeMode.light,
                currentMode,
              ),
              _themeOption(
                context,
                ref,
                "Dark Mode",
                Icons.dark_mode,
                ThemeMode.dark,
                currentMode,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _themeOption(
      BuildContext context,
      WidgetRef ref,
      String title,
      IconData icon,
      ThemeMode mode,
      ThemeMode currentMode,
      ) {
    final isSelected = currentMode == mode;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing:
      isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
        ref.read(themeNotifierProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}
