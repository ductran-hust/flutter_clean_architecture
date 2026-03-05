import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_clean_architecture/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:flutter_clean_architecture/features/todo/data/models/todo_model.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._remote, this._local);

  final TodoRemoteDataSource _remote;
  final TodoLocalDataSource _local;

  @override
  Future<List<TodoEntity>> getTodos() async {
    try {
      final models = await _remote.getTodos();
      await _local.saveAll(models);
      return models.map((m) => m.toEntity()).toList();
    } on NetworkFailure {
      final cached = await _local.getAll();
      return cached.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<TodoEntity> getTodoById(String id) async {
    try {
      final model = await _remote.getTodoById(id);
      await _local.save(model);
      return model.toEntity();
    } on NetworkFailure {
      final cached = await _local.getById(id);
      if (cached != null) return cached.toEntity();
      throw CacheFailure();
    }
  }

  @override
  Future<TodoEntity> createTodo({required String title, required String description}) async {
    try {
      final model = await _remote.createTodo({'title': title, 'description': description});
      await _local.save(model);
      return model.toEntity();
    } on NetworkFailure {
      // Optimistic local creation
      final localModel = TodoModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        isCompleted: false,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _local.save(localModel);
      return localModel.toEntity();
    }
  }

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) async {
    final model = await _remote.updateTodo(todo.id, TodoModel.fromEntity(todo));
    await _local.save(model);
    return model.toEntity();
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _remote.deleteTodo(id);
    await _local.delete(id);
  }

  @override
  Future<void> deleteCompletedTodos() async {
    final completed = await _local.getByStatus();
    await _remote.deleteCompletedTodos();
    await _local.deleteAll(completed.map((t) => t.id).toList());
  }

  @override
  Future<TodoEntity> toggleTodoCompletion(String id) async {
    final model = await _remote.toggleTodoCompletion(id);
    await _local.save(model);
    return model.toEntity();
  }
}
