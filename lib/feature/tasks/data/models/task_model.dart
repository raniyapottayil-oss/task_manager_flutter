import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

@HiveType(typeId: 0)
class TaskModel extends Task {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @override
  final bool completed;

  @HiveField(3)
  @override
  final bool isSynced;

  @HiveField(4)
  @override
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.completed,
    required this.isSynced,
    required this.updatedAt,
  }) : super(
          id: id,
          title: title,
          completed: completed,
          isSynced: isSynced,
          updatedAt: updatedAt,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'],
      completed: json['completed'] ?? false,
      isSynced: true,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      completed: task.completed,
      isSynced: task.isSynced,
      updatedAt: task.updatedAt,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      completed: completed,
      isSynced: isSynced,
      updatedAt: updatedAt,
    );
  }
}
