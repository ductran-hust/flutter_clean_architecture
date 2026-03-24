import 'package:flutter/material.dart';

/// Design tokens extracted from Figma screens.
///
/// Primary palette  : #8687E7 / #8875FF (purple)
/// Dark bg          : #121212 (scaffold), #1D1D1D (surface/card)
/// Error            : #FF4949 / #E2425C
/// Text on dark     : white 87% / #AFAFAF / #535353
@immutable
final class AppColors extends ThemeExtension<AppColors> {
  // ── Brand ──────────────────────────────────────────────────────────────────
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  // ── Secondary ──────────────────────────────────────────────────────────────
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;

  // ── Semantic ───────────────────────────────────────────────────────────────
  final Color error;
  final Color errorLight;
  final Color success;
  final Color warning;

  // ── Neutrals ───────────────────────────────────────────────────────────────
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onBackground;
  final Color onSurface;
  final Color onSurfaceMuted;

  final Color grey50;
  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey800;
  final Color grey900;

  const AppColors._({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.error,
    required this.errorLight,
    required this.success,
    required this.warning,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onBackground,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.grey50,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey800,
    required this.grey900,
  });

  // ── Light theme ────────────────────────────────────────────────────────────
  static const AppColors light = AppColors._(
    // Brand — same purple across both themes, just context differs
    primary: Color(0xFF8687E7),
    primaryLight: Color(0xFFB4B5FF),
    primaryDark: Color(0xFF5C5DB4),

    secondary: Color(0xFF8875FF),
    secondaryLight: Color(0xFFB4A8FF),
    secondaryDark: Color(0xFF6050D4),

    error: Color(0xFFE2425C),
    errorLight: Color(0xFFFFCACE),
    success: Color(0xFF34A853),
    warning: Color(0xFFFBBC05),

    background: Color(0xFFF5F5F5),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEEEEEE),
    onBackground: Color(0xFF121212),
    onSurface: Color(0xFF1D1D1D),
    onSurfaceMuted: Color(0xFF535353),

    grey50: Color(0xFFFAFAFA),
    grey100: Color(0xFFF5F5F5),
    grey200: Color(0xFFEEEEEE),
    grey300: Color(0xFFE0E0E0),
    grey500: Color(0xFF9E9E9E),
    grey600: Color(0xFF757575),
    grey700: Color(0xFF616161),
    grey800: Color(0xFF424242),
    grey900: Color(0xFF212121),
  );

  // ── Dark theme (matches Figma: bg #121212, surface #1D1D1D) ───────────────
  static const AppColors dark = AppColors._(
    primary: Color(0xFF8687E7),
    primaryLight: Color(0xFFB4B5FF),
    primaryDark: Color(0xFF5C5DB4),

    secondary: Color(0xFF8875FF),
    secondaryLight: Color(0xFFB4A8FF),
    secondaryDark: Color(0xFF6050D4),

    error: Color(0xFFFF4949),
    errorLight: Color(0xFFFFC1C1),
    success: Color(0xFF34A853),
    warning: Color(0xFFFBBC05),

    background: Color(0xFF121212),
    surface: Color(0xFF1D1D1D),
    surfaceVariant: Color(0xFF363636),
    onBackground: Color(0xDEFFFFFF), // white 87%
    onSurface: Color(0xDEFFFFFF),
    onSurfaceMuted: Color(0xFFAFAFAF),

    grey50: Color(0xFF2C2C2C),
    grey100: Color(0xFF3A3A3A),
    grey200: Color(0xFF484848),
    grey300: Color(0xFF535353),
    grey500: Color(0xFF797979),
    grey600: Color(0xFF979797),
    grey700: Color(0xFFA5A5A5),
    grey800: Color(0xFFCCCCCC),
    grey900: Color(0xFFEEEEEE),
  );

  // ── ThemeExtension impl ────────────────────────────────────────────────────
  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? secondary,
    Color? secondaryLight,
    Color? secondaryDark,
    Color? error,
    Color? errorLight,
    Color? success,
    Color? warning,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? onBackground,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? grey50,
    Color? grey100,
    Color? grey200,
    Color? grey300,
    Color? grey500,
    Color? grey600,
    Color? grey700,
    Color? grey800,
    Color? grey900,
  }) {
    return AppColors._(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      grey50: grey50 ?? this.grey50,
      grey100: grey100 ?? this.grey100,
      grey200: grey200 ?? this.grey200,
      grey300: grey300 ?? this.grey300,
      grey500: grey500 ?? this.grey500,
      grey600: grey600 ?? this.grey600,
      grey700: grey700 ?? this.grey700,
      grey800: grey800 ?? this.grey800,
      grey900: grey900 ?? this.grey900,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors._(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryLight: Color.lerp(secondaryLight, other.secondaryLight, t)!,
      secondaryDark: Color.lerp(secondaryDark, other.secondaryDark, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      grey50: Color.lerp(grey50, other.grey50, t)!,
      grey100: Color.lerp(grey100, other.grey100, t)!,
      grey200: Color.lerp(grey200, other.grey200, t)!,
      grey300: Color.lerp(grey300, other.grey300, t)!,
      grey500: Color.lerp(grey500, other.grey500, t)!,
      grey600: Color.lerp(grey600, other.grey600, t)!,
      grey700: Color.lerp(grey700, other.grey700, t)!,
      grey800: Color.lerp(grey800, other.grey800, t)!,
      grey900: Color.lerp(grey900, other.grey900, t)!,
    );
  }
}

/// Convenient extension to access AppColors from any BuildContext.
extension AppColorsX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.dark;
}