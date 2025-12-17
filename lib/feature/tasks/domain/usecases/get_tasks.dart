import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksParams {
  final int page;
  final String query;

  GetTasksParams({this.page = 1, this.query = ''});
}

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<List<Task>> call({GetTasksParams? params}) {
    return repository.getTasks(
      page: params?.page ?? 1,
      query: params?.query ?? '',
    );
  }
}
