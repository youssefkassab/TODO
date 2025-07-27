import 'package:flutter/material.dart';

// Modern color palette
const _primaryColor = Color(0xFF6C63FF); // Modern purple
const _secondaryColor = Color(0xFF4D4CAC); // Darker purple
const _accentColor = Color(0xFF00BFA6); // Teal accent
const _errorColor = Color(0xFFFF5252);

// Light Theme
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: _primaryColor,
    onPrimary: Colors.white,
    primaryContainer: _primaryColor.withValues(alpha: 0.1),
    onPrimaryContainer: _primaryColor,
    secondary: _secondaryColor,
    onSecondary: Colors.white,
    tertiary: _accentColor,
    onTertiary: Colors.white,
    error: _errorColor,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.grey[900]!,
    surfaceContainerHighest: Colors.grey[100]!,
    onSurfaceVariant: Colors.grey[700]!,
    outline: Colors.grey[300]!,
    outlineVariant: Colors.grey[200]!,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    titleTextStyle: const TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black87,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.black87,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey[200]!),
    ),
    margin: const EdgeInsets.all(8),
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: _primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _primaryColor, width: 2),
    ),
    filled: true,
    fillColor: Colors.grey[100],
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: _primaryColor,
    onPrimary: Colors.white,
    primaryContainer: _primaryColor.withValues(alpha: 0.2),
    onPrimaryContainer: _primaryColor.withValues(alpha: 0.8),
    secondary: _secondaryColor,
    onSecondary: Colors.white,
    tertiary: _accentColor,
    onTertiary: Colors.white,
    error: _errorColor,
    onError: Colors.white,
    surface: const Color(0xFF1E1E1E),
    onSurface: Colors.white,
    surfaceContainerHighest: const Color(0xFF2D2D2D),
    onSurfaceVariant: Colors.grey[400]!,
    outline: Colors.grey[800]!,
    outlineVariant: Colors.grey[900]!,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    color: const Color(0xFF2D2D2D),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey[800]!),
    ),
    margin: const EdgeInsets.all(8),
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: _primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2D2D2D),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _primaryColor, width: 2),
    ),

    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
);
