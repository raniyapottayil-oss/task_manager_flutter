import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<void> markTaskAsSynced(String taskId);
  Future<List<TaskModel>> getUnsyncedTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskModel> box;

  TaskLocalDataSourceImpl(this.box);

  @override
  Future<List<TaskModel>> getTasks() async => box.values.toList();

  @override
  Future<void> saveTask(TaskModel task) async => await box.put(task.id, task);

  @override
  Future<void> updateTask(TaskModel task) async {
    if (box.containsKey(task.id)) await box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    if (box.containsKey(taskId)) await box.delete(taskId);
  }

  @override
  Future<void> markTaskAsSynced(String taskId) async {
    final task = box.get(taskId);
    if (task != null) {
      final updatedTask = TaskModel.fromEntity(
        task.toEntity().copyWith(isSynced: true),
      );
      await box.put(taskId, updatedTask);
    }
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async =>
      box.values.where((t) => !t.isSynced).toList();
}

extension TaskCopy on Task {
  Task copyWith({bool? isSynced, bool? completed, String? title}) {
    return Task(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt,
    );
  }
}

