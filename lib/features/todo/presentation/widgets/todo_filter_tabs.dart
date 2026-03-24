import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_state.dart';


class TodoFilterTabs extends StatelessWidget {
  const TodoFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.totalCount = 0,
    this.activeCount = 0,
    this.completedCount = 0,
  });

  final TodoFilter selectedFilter;
  final ValueChanged<TodoFilter> onFilterChanged;
  final int totalCount;
  final int activeCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterTab(
            label: LocaleKeys.todo_filter_all.tr(),
            count: totalCount,
            isSelected: selectedFilter == TodoFilter.all,
            onTap: () => onFilterChanged(TodoFilter.all),
            color: colors.primary,
            colors: colors,
          ),
          const SizedBox(width: 8),
          _FilterTab(
            label: LocaleKeys.todo_filter_active.tr(),
            count: activeCount,
            isSelected: selectedFilter == TodoFilter.active,
            onTap: () => onFilterChanged(TodoFilter.active),
            color: const Color(0xFF3B82F6),
            colors: colors,
          ),
          const SizedBox(width: 8),
          _FilterTab(
            label: LocaleKeys.todo_filter_completed.tr(),
            count: completedCount,
            isSelected: selectedFilter == TodoFilter.completed,
            onTap: () => onFilterChanged(TodoFilter.completed),
            color: const Color(0xFF22C55E),
            colors: colors,
          ),
        ],
      ),
    );
  }
}

/// Custom filter tab built on top of AppChip's visual language
/// but with expanded layout + count badge that AppChip doesn't support.
class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.colors,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color.withValues(alpha: 0.4) : colors.grey200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: textStyles.labelMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? color : colors.onSurfaceMuted,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.2) : colors.grey200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: textStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected ? color : colors.onSurfaceMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
