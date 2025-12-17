import '../repositories/task_repository.dart';

class SyncTasks {
  final TaskRepository repository;
  SyncTasks(this.repository);

  Future<void> call() {
    return repository.syncTasks();
  }
}
