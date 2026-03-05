import 'package:flutter/material.dart';


//AI prompt 6
class AppThemes {

  static final List<ThemeData> themes = [system, lightTheme, darkGreenTheme, redTheme, darkGreenTheme];

  static final ThemeData redTheme = ThemeData(
    primaryColor: Colors.red,
    scaffoldBackgroundColor: Colors.red[50],
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  );

  static final ThemeData darkGreenTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[900],
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );
  static final ThemeData system = ThemeData(
    
  );
}