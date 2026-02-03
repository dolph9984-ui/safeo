import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'SF Pro Display',

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground, 
      
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBackground, width: 1),
      ),
      
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      
      // Bordure rouge en cas d'erreur
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      
      // Bordure rouge quand on clique dedans et qu'il y a une erreur
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
  );
}