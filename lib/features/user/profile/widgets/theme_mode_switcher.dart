import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/theme_provider.dart';
// Import your theme provider path

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Helper to get text/icon based on current mode
    String getModeName(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system: return "System Default";
        case ThemeMode.light: return "Light Mode";
        case ThemeMode.dark: return "Dark Mode";
      }
    }

    IconData getModeIcon(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system: return Icons.settings_brightness;
        case ThemeMode.light: return Icons.light_mode;
        case ThemeMode.dark: return Icons.dark_mode;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showThemePicker(context, themeProvider),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            getModeIcon(themeProvider.themeMode),
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          "Appearance",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          getModeName(themeProvider.themeMode),
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      ),
    );
  }

  void _showThemePicker(BuildContext context, ThemeProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Theme", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _themeOption(context, "System Default", Icons.settings_brightness, ThemeMode.system, provider),
              _themeOption(context, "Light Mode", Icons.light_mode, ThemeMode.light, provider),
              _themeOption(context, "Dark Mode", Icons.dark_mode, ThemeMode.dark, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _themeOption(BuildContext context, String title, IconData icon, ThemeMode mode, ThemeProvider provider) {
    bool isSelected = provider.themeMode == mode;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.blue : null, fontWeight: isSelected ? FontWeight.bold : null)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
        provider.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}