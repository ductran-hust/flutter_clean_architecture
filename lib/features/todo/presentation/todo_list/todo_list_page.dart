import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/base/base_page.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_controller.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_state.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/widgets/todo_filter_tabs.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/widgets/todo_item_tile.dart';
import 'package:flutter_clean_architecture/routes/app_router.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_bar_view.dart';

@RoutePage()
class TodoListPage extends BasePage<TodoListController, TodoListState> {
  const TodoListPage({super.key});

  @override
  Widget builder(BuildContext context, TodoListController controller, TodoListState data) {
    final filtered = data.filteredTodos;

    return Scaffold(
      appBar: AppBarView(
        title: LocaleKeys.todo_list_title.tr(),
        actions: [
          if (data.completedCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: LocaleKeys.todo_list_clearCompleted.tr(),
              onPressed: () => controller.deleteCompletedTodos(),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SearchBar(
              hintText: LocaleKeys.todo_list_search.tr(),
              onChanged: (q) => controller.setSearchQuery(q),
              leading: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _SummaryChip(label: LocaleKeys.todo_list_total.tr(args: ['${data.totalCount}'])),
                const SizedBox(width: 8),
                _SummaryChip(
                  label: LocaleKeys.todo_list_active.tr(args: ['${data.activeCount}']),
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _SummaryChip(
                  label: LocaleKeys.todo_list_done.tr(args: ['${data.completedCount}']),
                  color: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TodoFilterTabs(
            selectedFilter: data.filter,
            onFilterChanged: (f) => controller.setFilter(f),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyState(filter: data.filter, query: data.searchQuery)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => TodoItemTile(
                      todo: filtered[i],
                      onToggle: () => controller.toggleTodoCompletion(filtered[i].id),
                      onEdit: () => _navigateToEdit(context, controller, filtered[i]),
                      onDelete: () => controller.deleteTodo(filtered[i].id),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(context, controller),
        icon: const Icon(Icons.add),
        label: Text(LocaleKeys.todo_list_add.tr()),
      ),
    );
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

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: TextStyle(color: color ?? Colors.grey[700])),
      backgroundColor: (color ?? Colors.grey).withValues(alpha: 0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter, required this.query});

  final TodoFilter filter;
  final String query;

  @override
  Widget build(BuildContext context) {
    final (icon, message) = query.isNotEmpty
        ? (Icons.search_off, LocaleKeys.todo_empty_search.tr(args: [query]))
        : switch (filter) {
            TodoFilter.all => (Icons.checklist, LocaleKeys.todo_empty_all.tr()),
            TodoFilter.active => (Icons.done_all, LocaleKeys.todo_empty_active.tr()),
            TodoFilter.completed => (
              Icons.radio_button_unchecked,
              LocaleKeys.todo_empty_completed.tr(),
            ),
          };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
