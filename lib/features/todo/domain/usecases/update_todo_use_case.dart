import 'package:flutter_clean_architecture/core/base/use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodoUseCase extends UseCase<TodoEntity, TodoEntity> {
  UpdateTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<TodoEntity> call(TodoEntity params) => _repository.updateTodo(params);
}
