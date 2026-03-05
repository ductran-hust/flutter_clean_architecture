import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';

abstract interface class TodoRepository {
  Future<List<TodoEntity>> getTodos();
  Future<TodoEntity> getTodoById(String id);
  Future<TodoEntity> createTodo({required String title, required String description});
  Future<TodoEntity> updateTodo(TodoEntity todo);
  Future<void> deleteTodo(String id);
  Future<void> deleteCompletedTodos();
  Future<TodoEntity> toggleTodoCompletion(String id);
}
