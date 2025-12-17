import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final bool completed;
  final bool isSynced;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.completed,
    required this.isSynced,
    required this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? completed,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, completed, isSynced, updatedAt];
}
