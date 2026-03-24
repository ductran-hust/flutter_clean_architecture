// ─────────────────────────────────────────────────────────────────────────────
// AppDivider
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

/// Horizontal divider, optionally with a centered label (e.g. "or").
///
/// ```dart
/// AppDivider()
/// AppDivider.labeled(label: 'or')
/// ```
class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.label, this.height = 32});

  const AppDivider.labeled({
    Key? key,
    required String label,
    double height = 32,
  }) : this(key: key, label: label, height: height);

  final String? label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (label == null) {
      return Divider(height: height, color: colors.grey200, thickness: 0.8);
    }

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Divider(color: colors.grey200, thickness: 0.8, height: 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.onSurfaceMuted,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: colors.grey200, thickness: 0.8, height: 0),
          ),
        ],
      ),
    );
  }
}