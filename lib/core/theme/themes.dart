import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';

/// Central theme definition.
/// Tokens are sourced directly from the Figma screens:
///   background  : #121212  (dark) / #F5F5F5 (light)
///   surface     : #1D1D1D  (dark) / #FFFFFF (light)
///   primary     : #8687E7  (purple — main CTA buttons)
///   border r.   : 4 px (buttons), ~4 px (inputs)
///   button h.   : 48 dp
abstract final class AppTheme {
  // ── Shared radii / sizes ──────────────────────────────────────────────────
  static const double _buttonRadius = 4.0;
  static const double _inputRadius = 4.0;
  static const double _cardRadius = 12.0;
  static const double _buttonHeight = 48.0;

  // ── Light ─────────────────────────────────────────────────────────────────
  static ThemeData get light => _build(
    brightness: Brightness.light,
    colors: AppColors.light,
  );

  // ── Dark ──────────────────────────────────────────────────────────────────
  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    colors: AppColors.dark,
  );

  // ── Builder ───────────────────────────────────────────────────────────────
  static ThemeData _build({
    required Brightness brightness,
    required AppColors colors,
  }) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme.dark(
      primary: colors.primary,
      onPrimary: Colors.white,
      primaryContainer: colors.primaryDark,
      onPrimaryContainer: Colors.white,
      secondary: colors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: colors.secondaryDark,
      onSecondaryContainer: Colors.white,
      error: colors.error,
      onError: Colors.white,
      errorContainer: colors.errorLight,
      surface: colors.surface,
      onSurface: colors.onSurface,
      onSurfaceVariant: colors.onSurfaceMuted,
      outline: colors.grey300,
      outlineVariant: colors.grey200,
      scrim: Colors.black54,
    )
        : ColorScheme.light(
      primary: colors.primary,
      onPrimary: Colors.white,
      primaryContainer: colors.primaryLight,
      onPrimaryContainer: colors.primaryDark,
      secondary: colors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: colors.secondaryLight,
      onSecondaryContainer: colors.secondaryDark,
      error: colors.error,
      errorContainer: colors.errorLight,
      surface: colors.surface,
      onSurface: colors.onSurface,
      onSurfaceVariant: colors.onSurfaceMuted,
      outline: colors.grey300,
      outlineVariant: colors.grey200,
      scrim: Colors.black38,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,

      // ── Extensions ──────────────────────────────────────────────────────
      extensions: [colors, AppTextStyles.base],

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: colors.background,
        foregroundColor: colors.onBackground,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.base.titleLarge.copyWith(
          color: colors.onBackground,
        ),
        iconTheme: IconThemeData(color: colors.onBackground),
      ),

      // ── Card ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          side: BorderSide(color: colors.grey200, width: 0.8),
        ),
      ),

      // ── Input decoration ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: colors.grey600, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: colors.grey600, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        hintStyle: AppTextStyles.base.bodyMedium.copyWith(
          color: colors.onSurfaceMuted,
        ),
        labelStyle: AppTextStyles.base.bodyMedium.copyWith(
          color: colors.onSurfaceMuted,
        ),
        errorStyle: AppTextStyles.base.bodySmall.copyWith(
          color: colors.error,
        ),
      ),

      // ── ElevatedButton ──────────────────────────────────────────────────
      // Primary CTA: filled purple, h = 48, rx = 4
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.primary.withOpacity(0.5),
          disabledForegroundColor: Colors.white60,
          minimumSize: const Size.fromHeight(_buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          elevation: 0,
          textStyle: AppTextStyles.base.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),

      // ── OutlinedButton ──────────────────────────────────────────────────
      // Secondary CTA: outline purple, h = 48
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          disabledForegroundColor: colors.primary.withOpacity(0.4),
          minimumSize: const Size.fromHeight(_buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          side: BorderSide(color: colors.primary, width: 1.5),
          elevation: 0,
          textStyle: AppTextStyles.base.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),

      // ── TextButton ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: AppTextStyles.base.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: const CircleBorder(),
      ),

      // ── Chip ────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceVariant,
        selectedColor: colors.primary.withOpacity(0.2),
        labelStyle: AppTextStyles.base.labelMedium,
        side: BorderSide(color: colors.grey200, width: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.grey200,
        thickness: 0.8,
        space: 0,
      ),

      // ── BottomNavigationBar ─────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurfaceMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── NavigationBar (M3) ──────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primary.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(
            color: active ? colors.primary : colors.onSurfaceMuted,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return AppTextStyles.base.labelSmall.copyWith(
            color: active ? colors.primary : colors.onSurfaceMuted,
          );
        }),
        elevation: 0,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        elevation: 4,
        titleTextStyle: AppTextStyles.base.titleLarge.copyWith(
          color: colors.onSurface,
        ),
        contentTextStyle: AppTextStyles.base.bodyMedium.copyWith(
          color: colors.onSurfaceMuted,
        ),
      ),

      // ── SnackBar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? colors.grey100 : colors.grey900,
        contentTextStyle: AppTextStyles.base.bodyMedium.copyWith(
          color: isDark ? colors.grey900 : colors.grey100,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── ListTile ────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: Colors.transparent,
        iconColor: colors.onSurfaceMuted,
        textColor: colors.onSurface,
      ),

      // ── Switch / Checkbox / Radio ────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.primary
              : colors.grey500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.primary.withOpacity(0.3)
              : colors.grey200;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.primary
              : Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: colors.grey500, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.primary
              : colors.grey500;
        }),
      ),

      // ── ProgressIndicator ────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        circularTrackColor: colors.primary.withOpacity(0.2),
        linearTrackColor: colors.primary.withOpacity(0.2),
      ),

      // ── TabBar ──────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: colors.primary,
        unselectedLabelColor: colors.onSurfaceMuted,
        labelStyle: AppTextStyles.base.labelLarge,
        unselectedLabelStyle: AppTextStyles.base.labelLarge,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // ── Text theme (forward M3 styles from our scale) ────────────────────
      textTheme: TextTheme(
        displayLarge: AppTextStyles.base.displayLarge,
        displayMedium: AppTextStyles.base.displayMedium,
        displaySmall: AppTextStyles.base.displaySmall,
        headlineLarge: AppTextStyles.base.headlineLarge,
        headlineMedium: AppTextStyles.base.headlineMedium,
        headlineSmall: AppTextStyles.base.headlineSmall,
        titleLarge: AppTextStyles.base.titleLarge,
        titleMedium: AppTextStyles.base.titleMedium,
        titleSmall: AppTextStyles.base.titleSmall,
        bodyLarge: AppTextStyles.base.bodyLarge,
        bodyMedium: AppTextStyles.base.bodyMedium,
        bodySmall: AppTextStyles.base.bodySmall,
        labelLarge: AppTextStyles.base.labelLarge,
        labelMedium: AppTextStyles.base.labelMedium,
        labelSmall: AppTextStyles.base.labelSmall,
      ).apply(
        bodyColor: colors.onSurface,
        displayColor: colors.onBackground,
      ),
    );
  }
}