
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;
  DeleteTask(this.repository);

  Future<void> call(String taskId) async {
    await repository.deleteTask(taskId);
  }
}
