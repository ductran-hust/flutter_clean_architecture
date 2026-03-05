import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_form_state.freezed.dart';

@freezed
class TodoFormState with _$TodoFormState {
  TodoFormState({this.title = '', this.description = '', this.initialTodo});

  @override
  final String title;
  @override
  final String description;
  @override
  final TodoEntity? initialTodo;

  bool get isEditMode => initialTodo != null;
  bool get isValid => title.trim().isNotEmpty;
}
