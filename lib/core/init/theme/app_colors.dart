import 'package:flutter/material.dart';

/// Centralized color palette for light and dark themes
class AppColors {
  AppColors._();

  // Primary Branding Colors
  static const Color primary = Color(0xFF0F4C81); // Classic Corporate Navy
  static const Color primaryDark = Color(0xFF1E6FBA);
  static const Color secondary = Color(0xFF00A896); // Vibrant Teal
  static const Color accent = Color(0xFFF4A261);

  // Status & Feedback Colors
  static const Color success = Color(0xFF2EC4B6);
  static const Color warning = Color(0xFFFF9F1C);
  static const Color error = Color(0xFFE63946);
  static const Color info = Color(0xFF3A86FF);

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Component Specific
  static const Color buttonDisabledBg = Color(0xFFCBD5E1);
  static const Color buttonDisabledText = Color(0xFF94A3B8);
  static const Color darkButtonDisabledBg = Color(0xFF334155);
  static const Color darkButtonDisabledText = Color(0xFF64748B);
}
