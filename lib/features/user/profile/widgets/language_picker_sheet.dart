import 'package:flutter/material.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/provider/language_provider.dart';

class LanguagePickerSheet extends StatelessWidget {
  final LanguageProvider provider;

  const LanguagePickerSheet({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.t('select_language'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _LanguageOption(
            name: "English",
            code: "en",
            provider: provider,
          ),
          _LanguageOption(
            name: "ភាសាខ្មែរ",
            code: "km",
            provider: provider,
          ),
        ],
      ),
    );
  }
}

// Private helper widget for the options
class _LanguageOption extends StatelessWidget {
  final String name;
  final String code;
  final LanguageProvider provider;

  const _LanguageOption({
    required this.name,
    required this.code,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = provider.currentLocale.languageCode == code;
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
        provider.changeLanguage(code);
        Navigator.pop(context); // Close sheet
      },
    );
  }
}