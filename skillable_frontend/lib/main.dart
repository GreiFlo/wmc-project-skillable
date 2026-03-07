import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:skillable_frontend/appthemes.dart';
import 'package:skillable_frontend/main_screen.dart';
import 'package:skillable_frontend/pages/login.dart';
import 'package:skillable_frontend/providers/theme_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    var systemTheme =
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    return MaterialApp(
      theme: themeNotifier.currentTheme == AppThemes.system
          ? (systemTheme ? AppThemes.darkTheme : AppThemes.lightTheme)
          : themeNotifier.currentTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
