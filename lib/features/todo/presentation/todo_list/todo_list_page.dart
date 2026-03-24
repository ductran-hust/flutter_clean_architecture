import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_clean_architecture/core/base/base_page.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_controller.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_state.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/widgets/todo_filter_tabs.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/widgets/todo_item_tile.dart';
import 'package:flutter_clean_architecture/routes/app_router.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_dialog.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_text_field.dart';

@RoutePage()
class TodoListPage extends BasePage<TodoListController, TodoListState> {
  const TodoListPage({super.key});

  @override
  Widget builder(BuildContext context, TodoListController controller, TodoListState data) {
    return _TodoListView(controller: controller, data: data);
  }
}

/// Extracted to StatefulWidget to manage StreamSubscription lifecycle.
class _TodoListView extends StatefulWidget {
  const _TodoListView({required this.controller, required this.data});

  final TodoListController controller;
  final TodoListState data;

  @override
  State<_TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<_TodoListView> {
  StreamSubscription<TodoMessage>? _messageSubscription;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageSubscription = widget.controller.messageStream.listen(_showMessage);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(TodoMessage message) {
    if (!mounted) return;
    final colors = context.appColors;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              message.isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message.text,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: message.isError ? colors.error : colors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: Duration(seconds: message.isError ? 3 : 2),
        action: message.isError
            ? SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<TodoListController>().state.data;
    final controller = widget.controller;
    final filtered = data.filteredTodos;
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

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
                          style: textStyles.headlineSmall.copyWith(
                            color: colors.onBackground,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getSubtitle(data),
                          style: textStyles.bodySmall.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (data.completedCount > 0)
                    Tooltip(
                      message: LocaleKeys.todo_list_clearCompleted.tr(),
                      child: GestureDetector(
                        onTap: () => _confirmClearCompleted(context, controller, data),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.delete_sweep_outlined, size: 20, color: colors.error),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Search Bar — AppTextField ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppTextField(
                controller: _searchController,
                hint: LocaleKeys.todo_list_search.tr(),
                prefixIcon: Icons.search_rounded,
                onChanged: controller.setSearchQuery,
                suffixIcon: data.searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          controller.setSearchQuery('');
                        },
                        child: Icon(Icons.close_rounded, size: 18, color: colors.onSurfaceMuted),
                      )
                    : null,
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
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
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

  // AppDialog.confirm
  Future<void> _confirmClearCompleted(
    BuildContext context,
    TodoListController controller,
    TodoListState data,
  ) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Clear Completed',
      message: 'Delete ${data.completedCount} completed todo${data.completedCount > 1 ? 's' : ''}?',
      confirmLabel: 'Delete All',
      cancelLabel: 'Cancel',
      isDangerous: true,
    );
    if (confirmed) {
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
    final textStyles = context.appTextStyles;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: textStyles.labelSmall.copyWith(color: colors.onSurfaceMuted),
            ),
            Text(
              '$percentage%',
              style: textStyles.labelSmall.copyWith(
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
            builder: (_, value, __) => LinearProgressIndicator(
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
    final textStyles = context.appTextStyles;

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
              style: textStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium.copyWith(
                color: colors.onSurfaceMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}