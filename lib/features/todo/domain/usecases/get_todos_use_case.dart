import 'package:flutter_clean_architecture/core/base/use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTodosUseCase extends NoParamsUseCase<List<TodoEntity>> {
  GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<List<TodoEntity>> call() => _repository.getTodos();
}
