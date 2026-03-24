// ─────────────────────────────────────────────────────────────────────────────
// AppListTile
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';

/// Styled ListTile matching the app's visual language.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textStyles.bodyMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: textStyles.bodySmall.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ] else if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: colors.onSurfaceMuted,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 0,
            color: colors.grey200,
            thickness: 0.8,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}