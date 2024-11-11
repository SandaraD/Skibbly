import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;//Default mode

  ThemeProvider() {
    _loadThemeFromPreferences();
  }

  void toggleTheme() async {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _saveThemeToPreferences();
    notifyListeners();
  }

  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveThemeToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', themeMode == ThemeMode.dark);
  }


  ThemeData getTheme() {
    return themeMode == ThemeMode.dark ? _darkTheme : _lightTheme;
  }

 //Light theme
  ThemeData _lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.grey[50],
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.cyan[600],
      secondary: Colors.teal[300],
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    cardColor: Colors.teal[100],
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.black),
      bodyText1: TextStyle(color: Colors.black),
    ),
  );

 //Dark theme
  ThemeData _darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.cyan[600],
      secondary: Colors.teal[300],
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    cardColor: Colors.teal[100],
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
  );
}




