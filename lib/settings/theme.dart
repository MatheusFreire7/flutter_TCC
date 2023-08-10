import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData _themeData = ThemeData.light(); // Defina o tema padrão da sua aplicação aqui
  static Color _appBarColor = Colors.white; // Defina a cor padrão do AppBar
  static Color _iconColor = Colors.black; // Defina a cor padrão dos ícones

  static ThemeData get themeData => _themeData;
  static Color get appBarColor => _appBarColor;
  static Color get iconColor => _iconColor;

  static void setThemeData(ThemeData themeData, Color appBarColor, Color iconColor) {
    _themeData = themeData;
    _appBarColor = appBarColor;
    _iconColor = iconColor;
  }
}
