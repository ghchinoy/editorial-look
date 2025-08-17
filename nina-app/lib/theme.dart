import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFF20D0D);
const Color lightBackgroundColor = Color(0xFFFCF8F8);
const Color lightSurfaceColor = Color(0xFFF4E7E7);
const Color lightTextColor = Color(0xFF1C0D0D);

const Color darkBackgroundColor = Color(0xFF121212);
const Color darkSurfaceColor = Color(0xFF1E1E1E);
const Color darkTextColor = Color(0xFFFFFFFF);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    background: lightBackgroundColor,
    surface: lightSurfaceColor,
    onBackground: lightTextColor,
    onSurface: lightTextColor,
  ),
  scaffoldBackgroundColor: lightBackgroundColor,
  cardColor: lightSurfaceColor,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: lightTextColor),
    bodyMedium: TextStyle(color: lightTextColor),
    displayLarge: TextStyle(color: lightTextColor),
    displayMedium: TextStyle(color: lightTextColor),
    displaySmall: TextStyle(color: lightTextColor),
    headlineMedium: TextStyle(color: lightTextColor),
    headlineSmall: TextStyle(color: lightTextColor),
    titleLarge: TextStyle(color: lightTextColor),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
    background: darkBackgroundColor,
    surface: darkSurfaceColor,
    onBackground: darkTextColor,
    onSurface: darkTextColor,
  ),
  scaffoldBackgroundColor: darkBackgroundColor,
  cardColor: darkSurfaceColor,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: darkTextColor),
    bodyMedium: TextStyle(color: darkTextColor),
    displayLarge: TextStyle(color: darkTextColor),
    displayMedium: TextStyle(color: darkTextColor),
    displaySmall: TextStyle(color: darkTextColor),
    headlineMedium: TextStyle(color: darkTextColor),
    headlineSmall: TextStyle(color: darkTextColor),
    titleLarge: TextStyle(color: darkTextColor),
  ),
);
