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
    } catch (_) {
      try {
        final cached = await _local.getAll();
        return cached.map((m) => m.toEntity()).toList();
      } catch (e) {
        throw CacheFailure(message: 'Failed to load todos: $e');
      }
    }
  }

  @override
  Future<TodoEntity> getTodoById(String id) async {
    if (id.isEmpty) throw NotFoundFailure(message: 'Invalid todo ID');

    try {
      final model = await _remote.getTodoById(id);
      await _local.save(model);
      return model.toEntity();
    } catch (_) {
      try {
        final cached = await _local.getById(id);
        if (cached != null) return cached.toEntity();
        throw NotFoundFailure(message: 'Todo not found');
      } catch (e) {
        if (e is Failure) rethrow;
        throw CacheFailure(message: 'Failed to load todo: $e');
      }
    }
  }

  @override
  Future<TodoEntity> createTodo({required String title, required String description}) async {
    // Validate at repository level
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw UnknownFailure(message: 'Title cannot be empty');
    }
    if (trimmedTitle.length < 2) {
      throw UnknownFailure(message: 'Title must be at least 2 characters');
    }

    final localModel = TodoModel(
      id: const Uuid().v4(),
      title: trimmedTitle,
      description: description.trim(),
      isCompleted: false,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await _local.save(localModel);
    } catch (e) {
      throw CacheFailure(message: 'Failed to save todo locally: $e');
    }

    try {
      final model = await _remote.createTodo({
        'title': trimmedTitle,
        'description': description.trim(),
      });
      await _local.save(model);
      return model.toEntity();
    } catch (_) {
      return localModel.toEntity();
    }
  }

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) async {
    // Validate
    if (todo.id.isEmpty) throw NotFoundFailure(message: 'Invalid todo ID');
    if (todo.title.trim().isEmpty) {
      throw UnknownFailure(message: 'Title cannot be empty');
    }

    final model = TodoModel.fromEntity(todo);

    try {
      await _local.save(model);
    } catch (e) {
      throw CacheFailure(message: 'Failed to update todo locally: $e');
    }

    try {
      final remote = await _remote.updateTodo(todo.id, model);
      await _local.save(remote);
      return remote.toEntity();
    } catch (_) {
      return model.toEntity();
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (id.isEmpty) throw NotFoundFailure(message: 'Invalid todo ID');

    try {
      await _local.delete(id);
    } catch (e) {
      throw CacheFailure(message: 'Failed to delete todo locally: $e');
    }

    try {
      await _remote.deleteTodo(id);
    } catch (_) {
      // silently ignore remote error — local is source of truth
    }
  }

  @override
  Future<void> deleteCompletedTodos() async {
    try {
      final completed = await _local.getByStatus();
      if (completed.isEmpty) return;
      await _local.deleteAll(completed.map((t) => t.id).toList());
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear completed todos: $e');
    }

    try {
      await _remote.deleteCompletedTodos();
    } catch (_) {
      // silently ignore remote error
    }
  }

  @override
  Future<TodoEntity> toggleTodoCompletion(String id) async {
    if (id.isEmpty) throw NotFoundFailure(message: 'Invalid todo ID');

    final cached = await _local.getById(id);
    if (cached == null) throw NotFoundFailure(message: 'Todo not found');

    final toggled = TodoModel(
      id: cached.id,
      title: cached.title,
      description: cached.description,
      isCompleted: !cached.isCompleted,
      createdAt: cached.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    try {
      await _local.save(toggled);
    } catch (e) {
      throw CacheFailure(message: 'Failed to update todo status: $e');
    }

    try {
      final remote = await _remote.toggleTodoCompletion(id);
      await _local.save(remote);
      return remote.toEntity();
    } catch (_) {
      return toggled.toEntity();
    }
  }
}
