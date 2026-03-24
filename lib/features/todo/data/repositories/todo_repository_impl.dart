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
    } catch (_) {
      final cached = await _local.getById(id);
      if (cached != null) return cached.toEntity();
      throw Exception('Todo not found');
    }
  }

  @override
  Future<TodoEntity> createTodo({required String title, required String description}) async {
    final localModel = TodoModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _local.save(localModel);

    try {
      final model = await _remote.createTodo({'title': title, 'description': description});
      await _local.save(model);
      return model.toEntity();
    } catch (_) {
      return localModel.toEntity();
    }
  }

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) async {
    final model = TodoModel.fromEntity(todo);
    await _local.save(model);

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
    await _local.delete(id);

    try {
      await _remote.deleteTodo(id);
    } catch (_) {
      // silently ignore remote error — local is source of truth
    }
  }

  @override
  Future<void> deleteCompletedTodos() async {
    final completed = await _local.getByStatus();
    await _local.deleteAll(completed.map((t) => t.id).toList());

    try {
      await _remote.deleteCompletedTodos();
    } catch (_) {
      // silently ignore remote error
    }
  }

  @override
  Future<TodoEntity> toggleTodoCompletion(String id) async {
    final cached = await _local.getById(id);
    if (cached == null) throw Exception('Todo not found');

    final toggled = TodoModel(
      id: cached.id,
      title: cached.title,
      description: cached.description,
      isCompleted: !cached.isCompleted,
      createdAt: cached.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
    await _local.save(toggled);

    try {
      final remote = await _remote.toggleTodoCompletion(id);
      await _local.save(remote);
      return remote.toEntity();
    } catch (_) {
      return toggled.toEntity();
    }
  }
}
