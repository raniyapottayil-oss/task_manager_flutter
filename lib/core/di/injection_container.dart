import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../feature/tasks/data/datasources/task_local_data_source.dart';
import '../../feature/tasks/data/datasources/task_remote_data_source.dart';
import '../../feature/tasks/data/models/task_model.dart';
import '../../feature/tasks/data/repositories/task_repository_impl.dart';
import '../../feature/tasks/domain/repositories/task_repository.dart';
import '../../feature/tasks/domain/usecases/create_task.dart';
import '../../feature/tasks/domain/usecases/delete_tasks.dart';
import '../../feature/tasks/domain/usecases/get_tasks.dart';
import '../../feature/tasks/domain/usecases/sync_tasks.dart';
import '../../feature/tasks/domain/usecases/task_usecases.dart';
import '../../feature/tasks/domain/usecases/update_tasks.dart';
import '../../feature/tasks/presentation/bloc/task_bloc.dart';
import '../network/connectivity_service.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  /// Core
  getIt.registerLazySingleton(() => ConnectivityService());
  getIt.registerLazySingleton(() => Connectivity());

  /// External
  final dio = Dio();
  final taskBox = await Hive.openBox<TaskModel>('tasks');

  getIt.registerLazySingleton(() => dio);
  getIt.registerLazySingleton(() => taskBox);

  /// Network
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  /// Data sources
  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(getIt()),
  );

  /// Repository
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      getIt(),
      getIt(),
      getIt(),
    ),
  );

  /// UseCases
  getIt.registerLazySingleton(
    () => TaskUseCases(
      getTasks: GetTasks(getIt()),
      createTask: CreateTask(getIt()),
     updateTask: UpdateTask(getIt()),
      deleteTask: DeleteTask(getIt()),
      syncTasks: SyncTasks(getIt()),
    ),
  );

  /// Bloc
  getIt.registerFactory(
    () => TaskBloc(
      useCases: getIt(),
      connectivityService: getIt(),
    ),
  );
}
