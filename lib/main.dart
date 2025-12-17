import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection_container.dart';
import 'feature/tasks/data/models/task_model.g.dart';
import 'feature/tasks/presentation/bloc/task_bloc.dart';
import 'feature/tasks/presentation/bloc/task_event.dart';
import 'feature/tasks/presentation/pages/task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TaskBloc>()..add(LoadTasks()),

      child: MaterialApp(
        title: 'Smart Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const TaskPage(),
      ),
    );
  }
}
