// ─────────────────────────────────────────────────────────────────────────────
// AppChip
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

/// Pill-shaped chip for filters, tags, and categories.
///
/// ```dart
/// AppChip(label: 'Work', isSelected: true, onTap: () {})
/// ```
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.leading,
    this.onDeleted,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? leading;
  final VoidCallback? onDeleted;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final activeColor = color ?? colors.primary;

    final bgColor = isSelected
        ? activeColor.withOpacity(0.15)
        : colors.surfaceVariant;
    final borderColor = isSelected ? activeColor : colors.grey200;
    final textColor = isSelected ? activeColor : colors.onSurfaceMuted;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(Icons.close, size: 14, color: textColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}