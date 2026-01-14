import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fixit/main.dart';
import 'package:fixit/core/provider/theme_provider.dart';
import 'package:fixit/core/provider/language_provider.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // 🚫 DO NOT use pumpAndSettle()
    await tester.pump(); // just one frame

    // App built successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
