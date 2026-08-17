import 'package:flutter/material.dart';

/// Centralized Renault Port color palette for light and dark themes
class AppColors {
  AppColors._();

  // Renault Brand Colors
  static const Color primary = Color(0xFFFFC800); // Iconic Renault Yellow/Amber
  static const Color primaryDark = Color(0xFFFFD54F);
  static const Color onPrimary = Color(0xFF111111); // Dark text on yellow button
  static const Color secondary = Color(0xFF1E293B); // Deep Slate
  static const Color accent = Color(0xFF0052CC);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
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
  static const Color buttonDisabledBg = Color(0xFFE2E8F0);
  static const Color buttonDisabledText = Color(0xFF94A3B8);
  static const Color darkButtonDisabledBg = Color(0xFF334155);
  static const Color darkButtonDisabledText = Color(0xFF64748B);
}
