import 'package:flutter/material.dart';
import 'package:skillable_frontend/appthemes.dart';

// AI prompt 6
class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppThemes.darkGreenTheme; // Start-Theme

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}