import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/provider/language_provider.dart';

class LanguagePickerSheet extends ConsumerWidget {
  const LanguagePickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(languageNotifierProvider);

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
            currentCode: currentLocale.languageCode,
            onTap: () {
              ref
                  .read(languageNotifierProvider.notifier)
                  .setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          _LanguageOption(
            name: "ភាសាខ្មែរ",
            code: "km",
            currentCode: currentLocale.languageCode,
            onTap: () {
              ref
                  .read(languageNotifierProvider.notifier)
                  .setLocale(const Locale('km'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String name;
  final String code;
  final String currentCode;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.name,
    required this.code,
    required this.currentCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentCode == code;

    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
      isSelected ? const Icon(Icons.check_circle) : null,
      onTap: onTap,
    );
  }
}
