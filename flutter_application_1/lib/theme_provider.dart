import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  //toggles between light and dark mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
