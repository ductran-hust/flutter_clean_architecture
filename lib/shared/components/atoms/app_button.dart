import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

/// Variants matching the Figma screens:
///   [filled]   — solid primary purple  (main CTA, e.g. "Login")
///   [outlined]  — transparent + purple border (secondary CTA, e.g. "Register")
///   [ghost]     — no border/fill, text only  (tertiary actions)
///   [danger]    — solid red (destructive actions)
enum AppButtonVariant { filled, outlined, ghost, danger }

/// Sizes matching the Figma:
///   [large]   h = 48, font = 14 medium  (most screens)
///   [medium]  h = 40
///   [small]   h = 32, font = 12
enum AppButtonSize { large, medium, small }

/// A consistent, theme-aware button component.
///
/// ```dart
/// AppButton(
///   label: 'Login',
///   onPressed: _submit,
/// )
///
/// AppButton.outlined(
///   label: 'Register',
///   onPressed: () => context.router.push(const RegisterRoute()),
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  const AppButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    AppButtonSize size = AppButtonSize.large,
    bool isLoading = false,
    bool isFullWidth = true,
  }) : this(
    key: key,
    label: label,
    onPressed: onPressed,
    icon: icon,
    variant: AppButtonVariant.outlined,
    size: size,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  const AppButton.ghost({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    AppButtonSize size = AppButtonSize.large,
  }) : this(
    key: key,
    label: label,
    onPressed: onPressed,
    icon: icon,
    variant: AppButtonVariant.ghost,
    size: size,
  );

  const AppButton.danger({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    AppButtonSize size = AppButtonSize.large,
    bool isLoading = false,
    bool isFullWidth = true,
  }) : this(
    key: key,
    label: label,
    onPressed: onPressed,
    icon: icon,
    variant: AppButtonVariant.danger,
    size: size,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? trailingIcon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDisabled = onPressed == null || isLoading;

    final height = switch (size) {
      AppButtonSize.large => 48.0,
      AppButtonSize.medium => 40.0,
      AppButtonSize.small => 32.0,
    };

    final fontSize = switch (size) {
      AppButtonSize.large => 14.0,
      AppButtonSize.medium => 14.0,
      AppButtonSize.small => 12.0,
    };

    final iconSize = switch (size) {
      AppButtonSize.large => 20.0,
      AppButtonSize.medium => 18.0,
      AppButtonSize.small => 16.0,
    };

    final hPad = switch (size) {
      AppButtonSize.large => 24.0,
      AppButtonSize.medium => 20.0,
      AppButtonSize.small => 16.0,
    };

    Widget child = _buildChild(
      colors: colors,
      fontSize: fontSize,
      iconSize: iconSize,
      isDisabled: isDisabled,
    );

    if (isFullWidth) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return SizedBox(
      height: height,
      child: _buildButton(
        context: context,
        colors: colors,
        child: child,
        hPad: hPad,
        isDisabled: isDisabled,
      ),
    );
  }

  Widget _buildChild({
    required AppColors colors,
    required double fontSize,
    required double iconSize,
    required bool isDisabled,
  }) {
    if (isLoading) {
      final indicatorColor = switch (variant) {
        AppButtonVariant.filled => Colors.white,
        AppButtonVariant.danger => Colors.white,
        AppButtonVariant.outlined => colors.primary,
        AppButtonVariant.ghost => colors.primary,
      };
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: indicatorColor,
        ),
      );
    }

    final labelColor = switch (variant) {
      AppButtonVariant.filled => Colors.white,
      AppButtonVariant.danger => Colors.white,
      AppButtonVariant.outlined =>
      isDisabled ? colors.primary.withValues(alpha: 0.4) : colors.primary,
      AppButtonVariant.ghost =>
      isDisabled ? colors.primary.withValues(alpha: 0.4) : colors.primary,
    };

    final textWidget = Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: labelColor,
        letterSpacing: 0.1,
      ),
    );

    if (icon == null && trailingIcon == null) return textWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: icon,
          ),
          const SizedBox(width: 8),
        ],
        textWidget,
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: trailingIcon,
          ),
        ],
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required AppColors colors,
    required Widget child,
    required double hPad,
    required bool isDisabled,
  }) {
    const radius = BorderRadius.all(Radius.circular(12));
    final padding = EdgeInsets.symmetric(horizontal: hPad);

    switch (variant) {
      case AppButtonVariant.filled:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled
                ? colors.primary.withValues(alpha: 0.5)
                : colors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colors.primary.withValues(alpha: 0.5),
            shape: const RoundedRectangleBorder(borderRadius: radius),
            padding: padding,
            elevation: 0,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        );

      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.primary,
            side: BorderSide(
              color: isDisabled
                  ? colors.primary.withValues(alpha: 0.3)
                  : colors.primary,
              width: 1.5,
            ),
            shape: const RoundedRectangleBorder(borderRadius: radius),
            padding: padding,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        );

      case AppButtonVariant.ghost:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.primary,
            shape: const RoundedRectangleBorder(borderRadius: radius),
            padding: padding,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        );

      case AppButtonVariant.danger:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled
                ? colors.error.withValues(alpha: 0.5)
                : colors.error,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colors.error.withValues(alpha: 0.5),
            shape: const RoundedRectangleBorder(borderRadius: radius),
            padding: padding,
            elevation: 0,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        );
    }
  }
}