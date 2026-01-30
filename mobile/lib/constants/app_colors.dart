// lib/constants/app_colors.dart

import 'package:flutter/material.dart';

/// Centralizes all colors used throughout the SafeO app
class AppColors {
  // Couleur principale du design (bleu violet)
  static const Color primary = Color(0xFF5468FF);
  static const Color primaryDark = Color(0xFF4557E8);
  
  // Couleurs de fond
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;
  static const Color cardBackground = Color(0xFFF8F9FC);
  
  // Couleurs de texte
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  
  // Couleurs de bordure
  static const Color borderGray = Color(0xFFE5E7EB);
  static const Color inputBorder = Color(0xFFE5E7EB);
  
  // Couleurs d'état
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color success = Color(0xFF10B981);
  
  // Couleur pour l'illustration onboarding
  static const Color illustrationBlue = Color(0xFF93C5FD);
  static const Color illustrationBlueDark = Color(0xFF3B82F6);

  static Gradient? get headerGradient => null;
}