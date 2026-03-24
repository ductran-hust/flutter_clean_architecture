import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
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
          _FilterChip(
            label: LocaleKeys.todo_filter_all.tr(),
            count: totalCount,
            isSelected: selectedFilter == TodoFilter.all,
            onTap: () => onFilterChanged(TodoFilter.all),
            colors: colors,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: LocaleKeys.todo_filter_active.tr(),
            count: activeCount,
            isSelected: selectedFilter == TodoFilter.active,
            onTap: () => onFilterChanged(TodoFilter.active),
            colors: colors,
            activeColor: const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: LocaleKeys.todo_filter_completed.tr(),
            count: completedCount,
            isSelected: selectedFilter == TodoFilter.completed,
            onTap: () => onFilterChanged(TodoFilter.completed),
            colors: colors,
            activeColor: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    this.activeColor,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColors colors;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? colors.primary;

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
                style: TextStyle(
                  fontSize: 13,
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
                  style: TextStyle(
                    fontSize: 11,
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
