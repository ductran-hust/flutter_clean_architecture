import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.grey50,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey800,
    required this.grey900,
    required this.background,
    required this.surface,
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color grey50;
  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey800;
  final Color grey900;
  final Color background;
  final Color surface;

  // ── Light ─────────────────────────────────────────────
  static const light = AppColors(
    primary: Color(0xFF3B82F6),
    primaryLight: Color(0xFF93C5FD),
    primaryDark: Color(0xFF1D4ED8),
    secondary: Color(0xFF8B5CF6),
    secondaryLight: Color(0xFFC4B5FD),
    secondaryDark: Color(0xFF6D28D9),
    success: Color(0xFF22C55E),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    info: Color(0xFF06B6D4),
    grey50: Color(0xFFF9FAFB),
    grey100: Color(0xFFF3F4F6),
    grey200: Color(0xFFE5E7EB),
    grey300: Color(0xFFD1D5DB),
    grey400: Color(0xFF9CA3AF),
    grey500: Color(0xFF6B7280),
    grey600: Color(0xFF4B5563),
    grey700: Color(0xFF374151),
    grey800: Color(0xFF1F2937),
    grey900: Color(0xFF111827),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF8FAFC),
  );

  // ── Dark ──────────────────────────────────────────────
  static const dark = AppColors(
    primary: Color(0xFF93C5FD),
    primaryLight: Color(0xFFBFDBFE),
    primaryDark: Color(0xFF3B82F6),
    secondary: Color(0xFFC4B5FD),
    secondaryLight: Color(0xFFDDD6FE),
    secondaryDark: Color(0xFF8B5CF6),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
    info: Color(0xFF22D3EE),
    grey50: Color(0xFF111827),
    grey100: Color(0xFF1F2937),
    grey200: Color(0xFF374151),
    grey300: Color(0xFF4B5563),
    grey400: Color(0xFF6B7280),
    grey500: Color(0xFF9CA3AF),
    grey600: Color(0xFFD1D5DB),
    grey700: Color(0xFFE5E7EB),
    grey800: Color(0xFFF3F4F6),
    grey900: Color(0xFFF9FAFB),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? secondary,
    Color? secondaryLight,
    Color? secondaryDark,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? grey50,
    Color? grey100,
    Color? grey200,
    Color? grey300,
    Color? grey400,
    Color? grey500,
    Color? grey600,
    Color? grey700,
    Color? grey800,
    Color? grey900,
    Color? background,
    Color? surface,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      grey50: grey50 ?? this.grey50,
      grey100: grey100 ?? this.grey100,
      grey200: grey200 ?? this.grey200,
      grey300: grey300 ?? this.grey300,
      grey400: grey400 ?? this.grey400,
      grey500: grey500 ?? this.grey500,
      grey600: grey600 ?? this.grey600,
      grey700: grey700 ?? this.grey700,
      grey800: grey800 ?? this.grey800,
      grey900: grey900 ?? this.grey900,
      background: background ?? this.background,
      surface: surface ?? this.surface,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryLight: Color.lerp(secondaryLight, other.secondaryLight, t)!,
      secondaryDark: Color.lerp(secondaryDark, other.secondaryDark, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      grey50: Color.lerp(grey50, other.grey50, t)!,
      grey100: Color.lerp(grey100, other.grey100, t)!,
      grey200: Color.lerp(grey200, other.grey200, t)!,
      grey300: Color.lerp(grey300, other.grey300, t)!,
      grey400: Color.lerp(grey400, other.grey400, t)!,
      grey500: Color.lerp(grey500, other.grey500, t)!,
      grey600: Color.lerp(grey600, other.grey600, t)!,
      grey700: Color.lerp(grey700, other.grey700, t)!,
      grey800: Color.lerp(grey800, other.grey800, t)!,
      grey900: Color.lerp(grey900, other.grey900, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
    );
  }
}
