import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;
  CreateTask(this.repository);

  Future<void> call(Task task) async {
    await repository.createTask(task);
  }
}
