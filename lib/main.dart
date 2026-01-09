import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/provider/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixIt',

      // Light and Dark themes
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // Follow system setting
      // themeMode: ThemeMode.system,

      // follow light
      // themeMode: ThemeMode.light,

      // follow dark
      // themeMode: ThemeMode.dark,

      // Use provider in production
      themeMode: themeProvider.themeMode,


      // Platform-based routing
      initialRoute: AppRoutes.splash,

      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
