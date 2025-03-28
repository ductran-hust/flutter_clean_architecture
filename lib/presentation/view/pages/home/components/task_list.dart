import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/presentation/view/widgets/app_button.dart';

import '../home_bloc.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen:
          (preState, state) =>
              !const ListEquality().equals(preState.tasks, state.tasks),
      builder: (context, state) {
        final tasks = state.tasks;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              value: task.isCompleted,
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  color: task.isCompleted ? Colors.grey : Colors.black,
                ),
              ),
              secondary: AppButton.icon(
                child: const Icon(Icons.delete, color: Colors.red),
                onPressed:
                    () => context.read<HomeBloc>().add(
                      HomeEvent.deleteTask(task),
                    ),
              ),
              onChanged:
                  (_) => context.read<HomeBloc>().add(
                    HomeEvent.completeTask(task),
                  ),
            );
          },
        );
      },
    );
  }
}
