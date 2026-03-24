// ─────────────────────────────────────────────────────────────────────────────
// AppBadge
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

/// Small numerical badge (notification count, etc.).
///
/// ```dart
/// AppBadge(count: 3, child: Icon(Icons.notifications))
/// ```
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.child,
    this.count = 0,
    this.maxCount = 99,
    this.showWhenZero = false,
    this.color,
  });

  final Widget child;
  final int count;
  final int maxCount;
  final bool showWhenZero;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final show = showWhenZero || count > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (show)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: color ?? colors.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  count > maxCount ? '$maxCount+' : '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}