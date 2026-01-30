import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Import your new Riverpod-based controllers
import 'core/provider/theme_provider.dart';
import 'core/provider/language_provider.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    // 2. Replace MultiProvider with ProviderScope
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// 3. Change StatelessWidget to ConsumerWidget to access ref
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. Use ref.watch instead of context.watch
    final themeMode = ref.watch(themeNotifierProvider);
    final currentLocale = ref.watch(languageNotifierProvider);



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixIt',

      // 🌍 Localization
      locale: currentLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('km'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🎨 Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // 🚦 Routing
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}