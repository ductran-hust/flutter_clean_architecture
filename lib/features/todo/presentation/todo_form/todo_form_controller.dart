import 'package:flutter_clean_architecture/core/base/base_controller.dart';
import 'package:flutter_clean_architecture/core/base/base_state.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_form/todo_form_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TodoFormController extends BaseController<TodoFormState> {
  TodoFormController(@factoryParam TodoEntity? initialTodo)
    : super(BaseState(data: TodoFormState(initialTodo: initialTodo)));

  @override
  Future<void> initData() => launch(() async {});

  void updateTitle(String title) => updateData(state.data.copyWith(title: title));

  void updateDescription(String description) =>
      updateData(state.data.copyWith(description: description));

  TodoEntity buildEntity() {
    final data = state.data;
    final now = DateTime.now();

    if (data.isEditMode) {
      return data.initialTodo!.copyWith(
        title: data.title.trim(),
        description: data.description.trim(),
        updatedAt: now,
      );
    }

    return TodoEntity(
      id: '',
      title: data.title.trim(),
      description: data.description.trim(),
      isCompleted: false,
      createdAt: now,
    );
  }
}
