import 'dart:async';

import 'package:flutter_clean_architecture/core/base/base_controller.dart';
import 'package:flutter_clean_architecture/core/base/base_state.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/domain/usecases/create_todo_use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/usecases/delete_todo_use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/usecases/get_todos_use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/usecases/todo_action_use_cases.dart';
import 'package:flutter_clean_architecture/features/todo/domain/usecases/update_todo_use_case.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_state.dart';
import 'package:injectable/injectable.dart';

/// Enum for user-facing feedback messages.
enum TodoMessage {
  createSuccess('Todo created successfully'),
  createError('Failed to create todo'),
  updateSuccess('Todo updated successfully'),
  updateError('Failed to update todo'),
  deleteSuccess('Todo deleted'),
  deleteError('Failed to delete todo'),
  toggleSuccess('Todo status updated'),
  toggleError('Failed to update todo status'),
  clearSuccess('Completed todos cleared'),
  clearError('Failed to clear completed todos'),
  loadError('Failed to load todos');

  const TodoMessage(this.text);
  final String text;

  bool get isError => name.endsWith('Error');
}

@injectable
class TodoListController extends BaseController<TodoListState> {
  TodoListController(
    this._getTodos,
    this._createTodo,
    this._updateTodo,
    this._deleteTodo,
    this._toggleTodo,
    this._deleteCompleted,
  ) : super(BaseState(data: TodoListState()));

  final GetTodosUseCase _getTodos;
  final CreateTodoUseCase _createTodo;
  final UpdateTodoUseCase _updateTodo;
  final DeleteTodoUseCase _deleteTodo;
  final ToggleTodoCompletionUseCase _toggleTodo;
  final DeleteCompletedTodosUseCase _deleteCompleted;

  /// Stream of user-facing feedback messages (for SnackBar).
  final _messageController = StreamController<TodoMessage>.broadcast();
  Stream<TodoMessage> get messageStream => _messageController.stream;

  @override
  Future<void> close() {
    _messageController.close();
    return super.close();
  }

  @override
  Future<void> initData() => launch(() async {
    final todos = await _getTodos();
    updateData(state.data.copyWith(todos: todos));
  });

  Future<void> createTodo({required String title, required String description}) async {
    try {
      final todo = await _createTodo(CreateTodoParams(title: title, description: description));
      updateData(state.data.copyWith(todos: [...state.data.todos, todo]));
      _messageController.add(TodoMessage.createSuccess);
    } catch (e, s) {
      handleError(e, s);
      _messageController.add(TodoMessage.createError);
    }
  }

  Future<void> updateTodo(TodoEntity todo) async {
    try {
      final updated = await _updateTodo(todo);
      updateData(
        state.data.copyWith(
          todos: state.data.todos.map((t) => t.id == updated.id ? updated : t).toList(),
        ),
      );
      _messageController.add(TodoMessage.updateSuccess);
    } catch (e, s) {
      handleError(e, s);
      _messageController.add(TodoMessage.updateError);
    }
  }

  Future<void> toggleTodoCompletion(String id) async {
    // Optimistic update
    final original = state.data.todos;
    final optimistic = original.map((t) {
      if (t.id != id) return t;
      return t.copyWith(isCompleted: !t.isCompleted, updatedAt: DateTime.now());
    }).toList();
    updateData(state.data.copyWith(todos: optimistic));

    try {
      final updated = await _toggleTodo(id);
      updateData(
        state.data.copyWith(
          todos: state.data.todos.map((t) => t.id == updated.id ? updated : t).toList(),
        ),
      );
      _messageController.add(TodoMessage.toggleSuccess);
    } catch (e, s) {
      // Rollback
      updateData(state.data.copyWith(todos: original));
      handleError(e, s);
      _messageController.add(TodoMessage.toggleError);
    }
  }

  Future<void> deleteTodo(String id) async {
    // Optimistic delete — keep backup for rollback
    final original = state.data.todos;
    updateData(state.data.copyWith(todos: original.where((t) => t.id != id).toList()));

    try {
      await _deleteTodo(id);
      _messageController.add(TodoMessage.deleteSuccess);
    } catch (e, s) {
      // Rollback
      updateData(state.data.copyWith(todos: original));
      handleError(e, s);
      _messageController.add(TodoMessage.deleteError);
    }
  }

  Future<void> deleteCompletedTodos() async {
    final original = state.data.todos;
    updateData(state.data.copyWith(todos: original.where((t) => !t.isCompleted).toList()));

    try {
      await _deleteCompleted();
      _messageController.add(TodoMessage.clearSuccess);
    } catch (e, s) {
      // Rollback
      updateData(state.data.copyWith(todos: original));
      handleError(e, s);
      _messageController.add(TodoMessage.clearError);
    }
  }

  void setSearchQuery(String query) => updateData(state.data.copyWith(searchQuery: query));

  void setFilter(TodoFilter filter) => updateData(state.data.copyWith(filter: filter));
}
