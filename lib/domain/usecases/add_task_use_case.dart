import 'package:flutter_clean_architecture/domain/entities/task.dart';
import 'package:flutter_clean_architecture/domain/repositories/task_repository.dart';
import 'package:flutter_clean_architecture/shared/common/error_entity/error_entity.dart';
import 'package:flutter_clean_architecture/shared/common/validation_model.dart';
import 'package:injectable/injectable.dart';

import 'use_case.dart';

@injectable
class CreateTaskUseCase extends UseCase<bool, CreateTaskParam> {
  CreateTaskUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<bool> call({required CreateTaskParam params}) async {
    ErrorEntity? error;

    error ??= params.taskTitle.checkInputIsRequired();

    if(error != null) {
      throw error;
    }

    _taskRepository.addTask(Task.create(title: params.taskTitle.value!, categoryId: '1'));
    return true;
  }
}

class CreateTaskParam {
  CreateTaskParam(this.taskTitle);

  final ValidationModel<String> taskTitle;
}