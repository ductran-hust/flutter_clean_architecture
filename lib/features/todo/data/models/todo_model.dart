import 'package:flutter_clean_architecture/core/base/base_local_datasource.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
@HiveType(typeId: 0)
@JsonSerializable()
class TodoModel with _$TodoModel implements HiveModel {
  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
  });

  factory TodoModel.fromEntity(TodoEntity entity) => TodoModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    isCompleted: entity.isCompleted,
    createdAt: entity.createdAt.toIso8601String(),
    updatedAt: entity.updatedAt?.toIso8601String(),
  );

  factory TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final bool isCompleted;
  @override
  @HiveField(4)
  final String createdAt;
  @override
  @HiveField(5)
  final String? updatedAt;

  TodoEntity toEntity() => TodoEntity(
    id: id,
    title: title,
    description: description,
    isCompleted: isCompleted,
    createdAt: DateTime.parse(createdAt),
    updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
  );
}
