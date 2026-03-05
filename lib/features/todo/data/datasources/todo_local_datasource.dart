import 'package:flutter_clean_architecture/core/base/base_local_datasource.dart';
import 'package:flutter_clean_architecture/core/di/hive_module.dart';
import 'package:flutter_clean_architecture/features/todo/data/models/todo_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TodoLocalDataSource)
class TodoLocalDataSourceImpl extends BaseLocalDataSource<TodoModel>
    implements TodoLocalDataSource {
  TodoLocalDataSourceImpl(@Named(HiveBoxNames.todos) super.box);

  @override
  TodoModel fromJson(Map<String, dynamic> json) => TodoModel.fromJson(json);

  @override
  Future<List<TodoModel>> getByStatus({bool isCompleted = true}) async {
    final all = await getAll();
    return all.where((t) => t.isCompleted == isCompleted).toList();
  }
}

abstract interface class TodoLocalDataSource {
  Future<List<TodoModel>> getAll();
  Future<TodoModel?> getById(String id);
  Future<void> save(TodoModel todo);
  Future<void> saveAll(List<TodoModel> todos);
  Future<void> delete(String id);
  Future<void> deleteAll(List<String> ids);
  Future<void> clear();
  Future<List<TodoModel>> getByStatus({bool isCompleted});
}
