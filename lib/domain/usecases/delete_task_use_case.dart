import 'package:flutter_clean_architecture/domain/repositories/task_repository.dart';
import 'package:injectable/injectable.dart';

import 'use_case.dart';

@injectable
class DeleteTaskUseCase extends UseCase<void, DeleteTaskParam> {
  DeleteTaskUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<void> call({required DeleteTaskParam params}) async {
    _taskRepository.deleteTask(params.taskId);
  }
}

class DeleteTaskParam {
  DeleteTaskParam(this.taskId);

  final String taskId;
}