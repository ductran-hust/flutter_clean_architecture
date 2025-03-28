import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/domain/usecases/add_task_use_case.dart';
import 'package:flutter_clean_architecture/shared/common/error_entity/validation_error_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/common/error_converter.dart';
import '../../../../shared/common/validation_model.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';

part 'new_task_bloc.freezed.dart';
part 'new_task_event.dart';
part 'new_task_state.dart';

@injectable
class NewTaskBloc extends BaseBloc<NewTaskEvent, NewTaskState> {
  NewTaskBloc(this._createTaskUseCase) : super(const NewTaskState()) {
    on<NewTaskEvent>((event, emit) async {
        try {
          switch(event) {
            case _LoadData():
              emit(state.copyWith(pageStatus: PageStatus.Loaded));
              break;
            case _UpdateTaskTitle(taskTitle: final taskTitle):
              emit(state.copyWith(taskTitle: state.taskTitle.copyWith(taskTitle)));
              break;
            case _CreateTask():
              await _createTaskUseCase.call(params: CreateTaskParam(state.taskTitle));
              emit(state.copyWith(createTaskSuccess: true));
              break;
          }
        } catch(e,s) {
            handleError(emit, ErrorConverter.convert(e, s));
        }
    });
  }

  @override
  void handleError<S>(Emitter<S> emit, Object error) {
    if(error is ValidationErrorEntity) {
      if(error.key == TASK_TITLE) {
        emit(state.copyWith(taskTitle: state.taskTitle.copyWithError(error.message)) as S);
      }
    } else {
      super.handleError(emit, error);
    }
  }

  final CreateTaskUseCase _createTaskUseCase;
}