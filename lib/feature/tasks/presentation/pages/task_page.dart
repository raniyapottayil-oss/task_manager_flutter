import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager_flutter/core/constans/Strings.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../../domain/entities/task.dart';
import '../widgets/app_custom_textfield.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
  elevation: 0,
  backgroundColor: Theme.of(context).colorScheme.surface,
  centerTitle: false,
  title: const Text(
    'Smart Tasks',
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  ),
  forceMaterialTransparency: true,
  actions: [
    IconButton(
      tooltip: 'Add Task',
      icon: const Icon(Icons.add_circle_outline),
      onPressed: () => _showAddEditTaskCupertinoDialog(context),
    ),
    const SizedBox(width: 8),
  ],
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(70),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: (value) {
          context.read<TaskBloc>().add(SearchTasks(value));
        },
        decoration: InputDecoration(
          hintText: 'Search tasks',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  ),
),

      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CupertinoActivityIndicator(
    radius: 14,
  ),);
          }

          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text(AppStrings.noDataFound));
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 100) {
                  context.read<TaskBloc>().add(LoadMoreTasks());
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<TaskBloc>().add(RefreshTasks());
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;

                    if (isTablet) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: state.hasReachedMax
                            ? state.tasks.length
                            : state.tasks.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.tasks.length) {
                            return const Center(
                              child: CupertinoActivityIndicator(
    radius: 14,
  ),
                            );
                          }
                          return _buildTaskCard(
                            context,
                            state.tasks[index],
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      itemCount: state.hasReachedMax
                          ? state.tasks.length
                          : state.tasks.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.tasks.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: CupertinoActivityIndicator(
    radius: 14,
  ),
                            ),
                          );
                        }
                        return _buildTaskCard(
                          context,
                          state.tasks[index],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }

          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTasks());
                    },
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // --------------------------------------------------
  // TASK CARD
  // --------------------------------------------------

Widget _buildTaskCard(BuildContext context, Task task) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Slidable(
      key: ValueKey(task.id),

      // LEFT → RIGHT actions
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (_) {
              _showAddEditTaskCupertinoDialog(
                context,
                task: task,
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) {
              context.read<TaskBloc>().add(
                    UpdateTaskEvent(
                      task.copyWith(
                        completed: !task.completed,
                        updatedAt: DateTime.now(),
                        isSynced: false,
                      ),
                    ),
                  );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: task.completed
                ? Icons.undo
                : Icons.check_circle,
            label: task.completed ? AppStrings.undo : AppStrings.done,
          ),
        ],
      ),

      // RIGHT → LEFT actions
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              context.read<TaskBloc>().add(
                    DeleteTaskEvent(task),
                  );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: AppStrings.delete,
          ),
        ],
      ),

      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              decoration:
                  task.completed ? TextDecoration.lineThrough : null,
              color: task.completed ? Colors.grey : null,
            ),
          ),
          leading: task.completed
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked),
        ),
      ),
    ),
  );
}

  // --------------------------------------------------
  // CUPERTINO ADD / EDIT DIALOG
  // --------------------------------------------------

  Future<void> _showAddEditTaskCupertinoDialog(
    BuildContext context, {
    Task? task,
  }) async {
    final controller =
        TextEditingController(text: task?.title ?? '');
    final isEditing = task != null;

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(isEditing ? AppStrings.editTask : AppStrings.addTask),
          content: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Material(
              color: Colors.transparent,
              child: CustomTextField(
                controller: controller,
                labelText: AppStrings.taskTitle,
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 100,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
         onPressed: () {
  final title = controller.text.trim();
  if (title.isEmpty) return;

  final bloc = context.read<TaskBloc>();

  if (isEditing) {
    bloc.add(
      UpdateTaskEvent(
        task.copyWith(
          title: title,
          updatedAt: DateTime.now(),
          isSynced: false,
        ),
      ),
    );
  } else {
    bloc.add(AddTask(title));
  }

  Navigator.pop(context);
},
  child: Text(isEditing ? AppStrings.update : AppStrings.add),
            ),
          ],
        );
      },
    );
  }
}
