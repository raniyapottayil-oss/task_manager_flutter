import '../../domain/entities/task.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final bool hasReachedMax;
  final String query;

   TaskLoaded({
    required this.tasks,
    required this.hasReachedMax,
    required this.query,
  });

  TaskLoaded copyWith({
    List<Task>? tasks,
    bool? hasReachedMax,
    String? query,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
    );
  }
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
