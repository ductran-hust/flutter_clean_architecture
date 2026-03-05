import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_state.dart';

class TodoFilterTabs extends StatelessWidget {
  const TodoFilterTabs({super.key, required this.selectedFilter, required this.onFilterChanged});

  final TodoFilter selectedFilter;
  final ValueChanged<TodoFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<TodoFilter>(
        segments: [
          ButtonSegment(value: TodoFilter.all, label: Text(LocaleKeys.todo_filter_all.tr())),
          ButtonSegment(value: TodoFilter.active, label: Text(LocaleKeys.todo_filter_active.tr())),
          ButtonSegment(
            value: TodoFilter.completed,
            label: Text(LocaleKeys.todo_filter_completed.tr()),
          ),
        ],
        selected: {selectedFilter},
        onSelectionChanged: (s) => onFilterChanged(s.first),
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      ),
    );
  }
}
