import '../../domain/entities/task.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}
class LoadMoreTasks extends TaskEvent {}
class RefreshTasks extends TaskEvent {}
class SearchTasks extends TaskEvent {
  final String query;
  SearchTasks(this.query);
}

class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

class SyncPendingTasks extends TaskEvent {}
class DeleteTaskEvent extends TaskEvent {
  final Task task;
  DeleteTaskEvent(this.task);
}
class ConnectivityChanged extends TaskEvent {
  final bool isConnected;
  ConnectivityChanged(this.isConnected);
}

