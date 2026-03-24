
// ─────────────────────────────────────────────────────────────────────────────
// AppStatusTag
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

enum AppStatusTagType { success, error, warning, info, neutral }

/// Colored pill tag for status indicators.
///
/// ```dart
/// AppStatusTag(label: 'Active', type: AppStatusTagType.success)
/// ```
class AppStatusTag extends StatelessWidget {
  const AppStatusTag({
    super.key,
    required this.label,
    this.type = AppStatusTagType.neutral,
    this.icon,
  });

  final String label;
  final AppStatusTagType type;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final (bg, text) = switch (type) {
      AppStatusTagType.success => (
      colors.success.withOpacity(0.15),
      colors.success,
      ),
      AppStatusTagType.error => (
      colors.errorLight,
      colors.error,
      ),
      AppStatusTagType.warning => (
      colors.warning.withOpacity(0.15),
      colors.warning,
      ),
      AppStatusTagType.info => (
      colors.primary.withOpacity(0.15),
      colors.primary,
      ),
      AppStatusTagType.neutral => (
      colors.surfaceVariant,
      colors.onSurfaceMuted,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: text),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}