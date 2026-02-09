import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    
    // Font par défaut pour toute l'application
    fontFamily: AppFonts.productSansRegular,

    // Define color scheme for errors and other semantic colors
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: AppFonts.zalandoSans,
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontFamily: AppFonts.productSansMedium,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppFonts.productSansRegular,
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontFamily: AppFonts.productSansRegular,
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,

      hintStyle: TextStyle(
        fontFamily: AppFonts.productSansRegular,
        color: AppColors.textHint,
        fontSize: 14,
      ),
      
      errorStyle: TextStyle(
        fontFamily: AppFonts.productSansRegular,
        fontSize: 12,
      ),
      
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.inputBackground,
          width: 1,
        ),
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
        disabledBackgroundColor: AppColors.buttonDisabled,
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 56),
        textStyle: TextStyle(
          fontFamily: AppFonts.productSansMedium,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: Color(0xFFE2E2E2)),
        textStyle: TextStyle(
          fontFamily: AppFonts.productSansMedium,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}