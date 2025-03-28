part of 'new_task_bloc.dart';

const TASK_TITLE = 'title';

@freezed
class NewTaskState extends BaseState with _$NewTaskState {
  const NewTaskState({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
    this.taskTitle = const ValidationModel(TASK_TITLE),
    this.createTaskSuccess = false,
  });

  @override
  final ValidationModel<String> taskTitle;

  final bool createTaskSuccess;
}
