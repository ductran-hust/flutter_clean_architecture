import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_form_state.freezed.dart';

@freezed
class TodoFormState with _$TodoFormState {
  TodoFormState({
    this.title = '',
    this.description = '',
    this.initialTodo,
    this.hasSubmitted = false,
  });

  @override
  final String title;
  @override
  final String description;
  @override
  final TodoEntity? initialTodo;
  @override
  final bool hasSubmitted;

  bool get isEditMode => initialTodo != null;

  // ── Title validation ──
  static const int titleMaxLength = 100;

  String? get titleError {
    if (!hasSubmitted) return null;
    final trimmed = title.trim();
    if (trimmed.isEmpty) return 'Title is required';
    if (trimmed.length < 2) return 'Title must be at least 2 characters';
    if (trimmed.length > titleMaxLength) return 'Title must be at most $titleMaxLength characters';
    return null;
  }

  bool get isTitleValid => title.trim().isNotEmpty && title.trim().length >= 2 && title.trim().length <= titleMaxLength;

  // ── Description validation ──
  static const int descMaxLength = 500;

  String? get descriptionError {
    if (!hasSubmitted) return null;
    final trimmed = description.trim();
    if (trimmed.length > descMaxLength) return 'Description must be at most $descMaxLength characters';
    return null;
  }

  bool get isDescriptionValid => description.trim().length <= descMaxLength;

  // ── Overall form validation ──
  bool get isValid => isTitleValid && isDescriptionValid;

  // ── Change detection for edit mode ──
  bool get hasChanges {
    if (isEditMode) {
      return title != initialTodo!.title || description != initialTodo!.description;
    }
    return title.isNotEmpty || description.isNotEmpty;
  }

  // ── Character counters ──
  int get titleCharCount => title.length;
  int get descCharCount => description.length;
}
