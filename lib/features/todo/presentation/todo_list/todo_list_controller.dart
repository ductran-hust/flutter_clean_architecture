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

  @override
  Future<void> initData() => launch(() async {
    final todos = await _getTodos();
    updateData(state.data.copyWith(todos: todos));
  });

  Future<void> createTodo({required String title, required String description}) => launch(() async {
    final todo = await _createTodo(CreateTodoParams(title: title, description: description));
    updateData(state.data.copyWith(todos: [...state.data.todos, todo]));
  });

  Future<void> updateTodo(TodoEntity todo) => launch(() async {
    final updated = await _updateTodo(todo);
    updateData(
      state.data.copyWith(
        todos: state.data.todos.map((t) => t.id == updated.id ? updated : t).toList(),
      ),
    );
  });

  Future<void> toggleTodoCompletion(String id) => launch(() async {
    final updated = await _toggleTodo(id);
    updateData(
      state.data.copyWith(
        todos: state.data.todos.map((t) => t.id == updated.id ? updated : t).toList(),
      ),
    );
  });

  Future<void> deleteTodo(String id) => launch(() async {
    await _deleteTodo(id);
    updateData(state.data.copyWith(todos: state.data.todos.where((t) => t.id != id).toList()));
  });

  Future<void> deleteCompletedTodos() => launch(() async {
    await _deleteCompleted();
    updateData(state.data.copyWith(todos: state.data.todos.where((t) => !t.isCompleted).toList()));
  });

  void setSearchQuery(String query) => updateData(state.data.copyWith(searchQuery: query));

  void setFilter(TodoFilter filter) => updateData(state.data.copyWith(filter: filter));
}
