import 'package:flutter_clean_architecture/core/base/use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleTodoCompletionUseCase extends UseCase<TodoEntity, String> {
  ToggleTodoCompletionUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<TodoEntity> call(String id) => _repository.toggleTodoCompletion(id);
}

@injectable
class DeleteCompletedTodosUseCase extends NoParamsUseCase<void> {
  DeleteCompletedTodosUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<void> call() => _repository.deleteCompletedTodos();
}
