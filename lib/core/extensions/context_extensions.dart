import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';

extension ContextExtension on BuildContext {
  // ── Material Theme ────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // ── Custom Colors (ThemeExtension) ────────────────────
  AppColors? get colors => Theme.of(this).extension<AppColors>();

  // ── Custom TextStyles (ThemeExtension) ────────────────
  AppTextStyles? get styles => Theme.of(this).extension<AppTextStyles>();

  // ── MediaQuery ────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  // ── Navigation ────────────────────────────────────────
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ── SnackBar ──────────────────────────────────────────
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: duration));
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: colorScheme.error));
  }
}
