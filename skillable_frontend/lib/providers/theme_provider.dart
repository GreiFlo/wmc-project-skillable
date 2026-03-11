import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillable_frontend/appthemes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    loadCurrentTheme();
  }

  Future<void> loadCurrentTheme() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var themeIndex = sharedPrefs.getInt('currentTheme');
    setTheme(
      themeIndex != null ? AppThemes.themes[themeIndex] : AppThemes.system,
    );
    notifyListeners();
  }

  ThemeData _currentTheme = AppThemes.darkGreenTheme;

  ThemeData get currentTheme => _currentTheme;

  Future<void> setTheme(ThemeData theme) async {
    _currentTheme = theme;

    var sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setInt('currentTheme', AppThemes.themes.indexOf(currentTheme));
    notifyListeners();
  }
}
