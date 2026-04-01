import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color seedColor = Color.fromARGB(255, 30, 25, 69);

  static const Map<String, Color> typeColors = {
    'fire': Color.fromARGB(255, 194, 70, 25),
    'water': Color.fromARGB(255, 133, 192, 255),
    'grass': Color(0xFF5DAA68),
    'electric': Color.fromARGB(255, 224, 180, 0),
    'dragon': Color.fromARGB(255, 97, 27, 27),
    'psychic': Color.fromARGB(255, 28, 79, 145),
    'ghost': Color.fromARGB(255, 125, 107, 154),
    'dark': Color.fromARGB(255, 51, 45, 41),
    'steel': Color.fromARGB(255, 156, 177, 190),
    'fairy': Color.fromARGB(255, 244, 185, 225),
  };

  static Color typeColor(String type) =>
      typeColors[type.toLowerCase()] ?? const Color.fromARGB(255, 223, 221, 221);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(221, 31, 23, 110),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        fontFamily: 'Kranky',
      );
}
