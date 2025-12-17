import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({int page, String query});
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> syncTasks();
}
