import 'package:flutter_clean_architecture/core/base/use_case.dart';
import 'package:flutter_clean_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteTodoUseCase extends UseCase<void, String> {
  DeleteTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<void> call(String id) => _repository.deleteTodo(id);
}
