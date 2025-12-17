import '../../../../core/network/network_info.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl(
    this.remote,
    this.local,
    this.networkInfo,
  );

  // --------------------------------------------------
  // GET TASKS (OFFLINE FIRST + SYNC)
  // --------------------------------------------------
 
  @override
  Future<List<Task>> getTasks({
    int page = 1,
    String query = '',
  }) async {
    // 🔹 Sync only if connected
    if (await networkInfo.isConnected) {
      await _syncRemoteToLocal();
    }

    var tasks = await local.getTasks();

    if (query.isNotEmpty) {
      tasks = tasks
          .where(
            (t) => t.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    // 🔹 Always sort latest first
    tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final start = (page - 1) * 10;
    final end = start + 10;

    if (start >= tasks.length) return [];

    return tasks
        .sublist(start, end > tasks.length ? tasks.length : end)
        .map((e) => e.toEntity())
        .toList();
  }

  // --------------------------------------------------
  // CREATE
  // --------------------------------------------------
  @override
  Future<void> createTask(Task task) async {
    final model = TaskModel.fromEntity(task);

    await local.saveTask(model);

    if (await networkInfo.isConnected) {
      await remote.addTask(model);
      await local.markTaskAsSynced(task.id);
    }
  }

  // --------------------------------------------------
  // UPDATE
  // --------------------------------------------------
  @override
  Future<void> updateTask(Task task) async {
    final model = TaskModel.fromEntity(task);

    await local.updateTask(model);

    if (await networkInfo.isConnected) {
      await remote.updateTask(model);
      await local.markTaskAsSynced(task.id);
    }
  }

  // --------------------------------------------------
  // DELETE
  // --------------------------------------------------
  @override
  Future<void> deleteTask(String taskId) async {
    await local.deleteTask(taskId);

    if (await networkInfo.isConnected) {
      await remote.deleteTask(taskId);
    }
  }

  // --------------------------------------------------
  // SYNC UNSYNCED TASKS
  // --------------------------------------------------
  @override
  Future<void> syncTasks() async {
    if (!await networkInfo.isConnected) return;

    final pendingTasks = await local.getUnsyncedTasks();

    for (final task in pendingTasks) {
      await remote.addTask(task);
      await local.markTaskAsSynced(task.id);
    }
  }
   Future<void> _syncRemoteToLocal() async {
    final remoteTasks = await remote.getTasks();
    final localTasks = await local.getTasks();

    final localMap = {
      for (final task in localTasks) task.id: task,
    };

    for (final remoteTask in remoteTasks) {
      final localTask = localMap[remoteTask.id];

      // 🔹 Only overwrite if remote is newer
      if (localTask == null ||
          remoteTask.updatedAt.isAfter(localTask.updatedAt)) {
        await local.saveTask(remoteTask);
      }
    }
  }
}
