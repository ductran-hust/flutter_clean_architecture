import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list_state.freezed.dart';

enum TodoFilter { all, active, completed }

@freezed
class TodoListState with _$TodoListState {
  TodoListState({this.todos = const [], this.searchQuery = '', this.filter = TodoFilter.all});

  @override
  final List<TodoEntity> todos;
  @override
  final String searchQuery;
  @override
  final TodoFilter filter;

  List<TodoEntity> get filteredTodos {
    var result = todos;

    if (searchQuery.isNotEmpty) {
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                t.description.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return switch (filter) {
      TodoFilter.all => result,
      TodoFilter.active => result.where((t) => !t.isCompleted).toList(),
      TodoFilter.completed => result.where((t) => t.isCompleted).toList(),
    };
  }

  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.isCompleted).length;
  int get activeCount => todos.where((t) => !t.isCompleted).length;
}
