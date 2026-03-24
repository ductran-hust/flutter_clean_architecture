// ─────────────────────────────────────────────────────────────────────────────
// AppAvatar
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

/// Circular avatar with fallback initials.
///
/// ```dart
/// AppAvatar(name: 'John Doe', imageUrl: user.avatarUrl, size: 48)
/// ```
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = 40,
    this.onTap,
  });

  final String? name;
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final initials = _initials(name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primary.withOpacity(0.2),
          image: imageUrl != null
              ? DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: imageUrl == null
            ? Center(
          child: Text(
            initials,
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
        )
            : null,
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}