import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/task_usecases.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskUseCases useCases;
  final ConnectivityService connectivityService;

  late final StreamSubscription<bool> _connectivitySub;

  int page = 1;
  bool isFetching = false;
  Timer? _debounce;
  String _currentQuery = '';

  TaskBloc({
    required this.useCases,
    required this.connectivityService,
  }) : super(TaskInitial()) {
    _connectivitySub =
        connectivityService.onConnectionChange.listen((isConnected) {
      add(ConnectivityChanged(isConnected));
    });

    on<ConnectivityChanged>(_onConnectivityChanged);
    on<LoadTasks>(_onLoadTasks);
    on<LoadMoreTasks>(_onLoadMoreTasks);
    on<SearchTasks>(_onSearchTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<RefreshTasks>(_onRefreshTasks);
  }

  Future<void> _onConnectivityChanged(
      ConnectivityChanged event, Emitter<TaskState> emit) async {
    if (event.isConnected) {
      await useCases.syncTasks();
      add(LoadTasks());
    }
  }

  Future<void> _onLoadTasks(
      LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    page = 1;

    final tasks = await useCases.getTasks(
      params: GetTasksParams(page: page, query: _currentQuery),
    );

    emit(TaskLoaded(
      tasks: tasks,
      hasReachedMax: tasks.length < 10,
      query: _currentQuery,
    ));
  }

  Future<void> _onLoadMoreTasks(
      LoadMoreTasks event, Emitter<TaskState> emit) async {
    if (state is! TaskLoaded || isFetching) return;

    isFetching = true;
    page++;

    final current = state as TaskLoaded;
    final newTasks = await useCases.getTasks(
      params: GetTasksParams(page: page, query: current.query),
    );

    emit(TaskLoaded(
      tasks: current.tasks + newTasks,
      hasReachedMax: newTasks.length < 10,
      query: current.query,
    ));

    isFetching = false;
  }

  Future<void> _onSearchTasks(
      SearchTasks event, Emitter<TaskState> emit) async {
    _currentQuery = event.query;
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      add(LoadTasks());
    });
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    final task = Task(
      id: const Uuid().v4(),
      title: event.title,
      completed: false,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await useCases.createTask(task);
    add(LoadTasks());
  }

Future<void> _onUpdateTask(
  UpdateTaskEvent event,
  Emitter<TaskState> emit,
) async {
  if (state is! TaskLoaded) return;

  final current = state as TaskLoaded;

  final updatedTasks = current.tasks.map((task) {
    if (task.id == event.task.id) {
      return event.task.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      );
    }
    return task;
  }).toList();

  emit(
    current.copyWith(
      tasks: updatedTasks,
    ),
  );
  await useCases.updateTask(event.task);
}


Future<void> _onDeleteTask(
  DeleteTaskEvent event,
  Emitter<TaskState> emit,
) async {
  if (state is! TaskLoaded) return;

  final current = state as TaskLoaded;

  final updatedTasks =
      current.tasks.where((t) => t.id != event.task.id).toList();

  emit(
    current.copyWith(
      tasks: updatedTasks,
    ),
  );

  await useCases.deleteTask(event.task.id);
}


Future<void> _onRefreshTasks(
  RefreshTasks event,
  Emitter<TaskState> emit,
) async {
  page = 1;
  _currentQuery = '';

  emit(TaskLoading());

  final tasks = await useCases.getTasks(
    params: GetTasksParams(page: page, query: _currentQuery),
  );

  emit(
    TaskLoaded(
      tasks: tasks,
      hasReachedMax: tasks.length < 10,
      query: _currentQuery,
    ),
  );
}

  @override
  Future<void> close() {
    _debounce?.cancel();
    _connectivitySub.cancel();
    return super.close();
  }
}
