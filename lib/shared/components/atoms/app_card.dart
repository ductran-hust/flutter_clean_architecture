import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppCard
// ─────────────────────────────────────────────────────────────────────────────

/// A surface card matching the Figma style.
/// Fill: surface (#1D1D1D dark / #FFF light), border: grey 0.8px, radius 12.
///
/// ```dart
/// AppCard(
///   padding: EdgeInsets.all(16),
///   child: Text('Hello'),
/// )
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderRadius = 12,
    this.showBorder = true,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool showBorder;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: color ?? colors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(color: colors.grey200, width: 0.8)
                : null,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}