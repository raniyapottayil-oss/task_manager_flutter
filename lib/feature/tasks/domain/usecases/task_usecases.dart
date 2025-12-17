import 'get_tasks.dart';
import 'create_task.dart';
import 'delete_tasks.dart';
import 'sync_tasks.dart';
import 'update_tasks.dart';

class TaskUseCases {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask; 
  final DeleteTask deleteTask;
  final SyncTasks syncTasks;

  TaskUseCases({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.syncTasks,
  });
}

