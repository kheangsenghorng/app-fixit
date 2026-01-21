import 'package:flutter/material.dart';
import 'theme_selection_item.dart';

class ThemeOptionsRow extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Color accentColor;
  final Function(ThemeMode) onThemeChanged;

  const ThemeOptionsRow({
    super.key,
    required this.currentThemeMode,
    required this.accentColor,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // We define our options in a list to map them with an index automatically
    final List<Map<String, dynamic>> options = [
      {'title': "Light", 'mode': ThemeMode.light, 'brightness': Brightness.light, 'isSystem': false},
      {'title': "Dark", 'mode': ThemeMode.dark, 'brightness': Brightness.dark, 'isSystem': false},
      {'title': "System", 'mode': ThemeMode.system, 'brightness': null, 'isSystem': true},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(options.length, (index) {
        final opt = options[index];
        return ThemeSelectionItem(
          index: index, // Passing the index for staggered delay
          title: opt['title'],
          mode: opt['mode'],
          brightness: opt['brightness'],
          isSystem: opt['isSystem'],
          currentThemeMode: currentThemeMode,
          accentColor: accentColor,
          onThemeChanged: onThemeChanged,
        );
      }),
    );
  }
}