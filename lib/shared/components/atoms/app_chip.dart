import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.prefixIcon,
    this.color,
  });

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;
  final IconData? prefixIcon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final c = color ?? scheme.primary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: 14, color: selected ? scheme.onPrimary : c),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      onDeleted: onDeleted,
      selectedColor: c,
      checkmarkColor: scheme.onPrimary,
      labelStyle: textTheme.labelMedium?.copyWith(
        color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
      ),
      backgroundColor: scheme.surfaceContainerHighest,
      side: BorderSide(color: selected ? c : scheme.outlineVariant),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
