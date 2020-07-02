import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme_data.dart';

enum AppTheme { DarkTheme, LightTheme }

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  var key = 'darkTheme';
  bool isDark = false;

  ThemeData get theme => _themeData ?? lightTheme;

  Future<void> fetchTheme() async {
    var prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool(key) ?? false;

    if (isDark) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
  }

  Future<void> changeTheme(AppTheme appTheme) async {
    var prefs = await SharedPreferences.getInstance();

    if (appTheme == AppTheme.DarkTheme && _themeData != darkTheme) {
      _themeData = darkTheme;
      isDark = true;
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
