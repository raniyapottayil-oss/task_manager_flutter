import 'package:dio/dio.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/todos');
    return (response.data as List)
        .take(10)
        .map((e) => TaskModel(
              id: e['id'].toString(),
              title: e['title'],
              completed: e['completed'] ?? false,
              isSynced: true,
              updatedAt: DateTime.now(),
            ))
        .toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await dio.post('https://jsonplaceholder.typicode.com/todos', data: task.toJson());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await dio.put('https://jsonplaceholder.typicode.com/todos/${task.id}', data: task.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await dio.delete('https://jsonplaceholder.typicode.com/todos/$taskId');
  }
}
