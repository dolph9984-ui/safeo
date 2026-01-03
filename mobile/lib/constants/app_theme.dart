import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';

/// Global theme configuration for the entire SafeO application
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    // Define color scheme for errors and other semantic colors
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      error: AppColors.error,
      errorContainer: AppColors.errorLight,
      onError: AppColors.errorDark,
      onErrorContainer: AppColors.errorDark,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),

    // Default style for all TextFields
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      hintStyle: TextStyle(color: AppColors.textSecondary),
      prefixIconColor: AppColors.primary,
      suffixIconColor: AppColors.primary, // ← Added: eye icon in blue automatically
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.borderGray, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 3),
      ),
      errorStyle: const TextStyle(color: AppColors.error),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderGray, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.primary, size: 28),

    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.textSecondary),
    ),
  );
}