import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_clean_architecture/core/base/base_page.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_controller.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_state.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/widgets/todo_filter_tabs.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/widgets/todo_item_tile.dart';
import 'package:flutter_clean_architecture/routes/app_router.dart';

@RoutePage()
class TodoListPage extends BasePage<TodoListController, TodoListState> {
  const TodoListPage({super.key});

  @override
  Widget builder(BuildContext context, TodoListController controller, TodoListState data) {
    final filtered = data.filteredTodos;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => context.router.maybePop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.grey200),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.todo_list_title.tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: colors.onBackground,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getSubtitle(data),
                          style: TextStyle(fontSize: 13, color: colors.onSurfaceMuted),
                        ),
                      ],
                    ),
                  ),
                  if (data.completedCount > 0)
                    _HeaderAction(
                      icon: Icons.delete_sweep_outlined,
                      tooltip: LocaleKeys.todo_list_clearCompleted.tr(),
                      onTap: () => _confirmClearCompleted(context, controller, data),
                      colors: colors,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.grey200),
                  boxShadow: [
                    BoxShadow(
                      color: colors.grey300.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: controller.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.todo_list_search.tr(),
                    hintStyle: TextStyle(color: colors.onSurfaceMuted, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: colors.onSurfaceMuted, size: 22),
                    suffixIcon: data.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close_rounded, size: 18, color: colors.onSurfaceMuted),
                            onPressed: () => controller.setSearchQuery(''),
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Filter Tabs ──
            TodoFilterTabs(
              selectedFilter: data.filter,
              onFilterChanged: controller.setFilter,
              totalCount: data.totalCount,
              activeCount: data.activeCount,
              completedCount: data.completedCount,
            ),

            const SizedBox(height: 12),

            // ── Progress bar ──
            if (data.totalCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ProgressBar(
                  completed: data.completedCount,
                  total: data.totalCount,
                  colors: colors,
                ),
              ),

            const SizedBox(height: 8),

            // ── List ──
            Expanded(
              child: filtered.isEmpty
                  ? _EmptyState(filter: data.filter, query: data.searchQuery, colors: colors)
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: ListView.separated(
                        key: ValueKey(data.filter),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemCount: filtered.length,
                                                separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => TodoItemTile(
                          todo: filtered[i],
                          onToggle: () => controller.toggleTodoCompletion(filtered[i].id),
                          onEdit: () => _navigateToEdit(context, controller, filtered[i]),
                          onDelete: () => controller.deleteTodo(filtered[i].id),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(context, controller),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          LocaleKeys.todo_list_add.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  String _getSubtitle(TodoListState data) {
    if (data.totalCount == 0) return 'No tasks yet';
    final remaining = data.activeCount;
    if (remaining == 0) return 'All tasks completed! 🎉';
    return '$remaining task${remaining > 1 ? 's' : ''} remaining';
  }

  Future<void> _confirmClearCompleted(
    BuildContext context,
    TodoListController controller,
    TodoListState data,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Completed'),
        content: Text(
          'Delete ${data.completedCount} completed todo${data.completedCount > 1 ? 's' : ''}?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteCompletedTodos();
    }
  }

  Future<void> _navigateToCreate(BuildContext context, TodoListController controller) async {
    final result = await context.router.push<TodoEntity>(TodoFormRoute());
    if (result != null) {
      await controller.createTodo(title: result.title, description: result.description);
    }
  }

  Future<void> _navigateToEdit(
    BuildContext context,
    TodoListController controller,
    TodoEntity todo,
  ) async {
    final result = await context.router.push<TodoEntity>(TodoFormRoute(initialTodo: todo));
    if (result != null) {
      await controller.updateTodo(result);
    }
  }
}

// ── Progress Bar ──

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.completed,
    required this.total,
    required this.colors,
  });

  final int completed;
  final int total;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    final percentage = (progress * 100).toInt();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurfaceMuted),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: progress == 1.0 ? colors.success : colors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
                        builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: colors.grey200,
              valueColor: AlwaysStoppedAnimation(
                progress == 1.0 ? colors.success : colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Header Action ──

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.colors,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: colors.error),
        ),
      ),
    );
  }
}

// ── Empty State ──

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.filter,
    required this.query,
    required this.colors,
  });

  final TodoFilter filter;
  final String query;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final (icon, message, subtitle) = query.isNotEmpty
        ? (Icons.search_off_rounded, 'No results', LocaleKeys.todo_empty_search.tr(args: [query]))
        : switch (filter) {
            TodoFilter.all => (
                Icons.task_alt_rounded,
                'No Tasks Yet',
                LocaleKeys.todo_empty_all.tr(),
              ),
            TodoFilter.active => (
                Icons.done_all_rounded,
                'All Done!',
                LocaleKeys.todo_empty_active.tr(),
              ),
            TodoFilter.completed => (
                Icons.radio_button_unchecked_rounded,
                'No Completed Tasks',
                LocaleKeys.todo_empty_completed.tr(),
              ),
          };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: colors.primary.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: colors.onSurfaceMuted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}