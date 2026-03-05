import 'package:flutter/material.dart';


//AI prompt 6
class AppThemes {
  static final ThemeData blueTheme = ThemeData(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

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

}