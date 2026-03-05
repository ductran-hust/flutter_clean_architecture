import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_entity.freezed.dart';

@freezed
class TodoEntity with _$TodoEntity {
  TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final bool isCompleted;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
}
