import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme_data.dart';

enum AppTheme { DarkTheme, LightTheme }

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  var key = 'darkTheme';
  bool isDark = false;

  /// App theme.
  ThemeData get theme => _themeData ?? lightTheme;

// Fetch stored theme bool from shared preference.
  Future<void> fetchTheme() async {
    var prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool(key) ?? false;

    if (isDark) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
  }

// change app theme and save bool to shared preference.
  Future<void> changeTheme(AppTheme appTheme) async {
    var prefs = await SharedPreferences.getInstance();
    // Check if new theme not equal current theme, and update ui.
    if (appTheme == AppTheme.DarkTheme && _themeData != darkTheme) {
      _themeData = darkTheme;
      isDark = true;
      // save bool to shared preferene
      await prefs.setBool(key, true);
      notifyListeners();
    } else if (appTheme == AppTheme.LightTheme && _themeData != lightTheme) {
      _themeData = lightTheme;
      isDark = false;
      await prefs.setBool(key, false);
      notifyListeners();
    }
  }
}
