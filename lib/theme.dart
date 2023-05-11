import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData _themeData = ThemeData.light(); // Defina o tema padrão da sua aplicação aqui

  static ThemeData get themeData => _themeData;

  static void setThemeData(ThemeData themeData) {
    _themeData = themeData;
  }
}
