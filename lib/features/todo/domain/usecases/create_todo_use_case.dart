import 'package:flutter_clean_architecture/core/base/use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

class CreateTodoParams {
  CreateTodoParams({required this.title, required this.description});

  final String title;
  final String description;
}

@injectable
class CreateTodoUseCase extends UseCase<TodoEntity, CreateTodoParams> {
  CreateTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<TodoEntity> call(CreateTodoParams params) =>
      _repository.createTodo(title: params.title, description: params.description);
}
