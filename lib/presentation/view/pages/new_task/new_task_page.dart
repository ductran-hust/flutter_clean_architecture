import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/presentation/view/widgets/app_button.dart';
import 'package:flutter_clean_architecture/presentation/view/widgets/app_form_field.dart';
import 'package:flutter_clean_architecture/shared/common/validation_model.dart';

import '../../../base/base_page.dart';
import 'new_task_bloc.dart';

@RoutePage()
class NewTaskPage extends BasePage<NewTaskBloc, NewTaskEvent, NewTaskState> {
  NewTaskPage({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();

  @override
  void onInitState(BuildContext context) {
    context.read<NewTaskBloc>().add(const NewTaskEvent.loadData());
    super.onInitState(context);
  }

  @override
  void onDispose(BuildContext context) {
    _titleController.dispose();
    super.onDispose(context);
  }

  @override
  Widget builder(BuildContext context) {
    return BlocListener<NewTaskBloc, NewTaskState>(
      listenWhen: (preState, state) {
        return preState.createTaskSuccess != state.createTaskSuccess;
      },
      listener: (context, state) {
        if (state.createTaskSuccess) {
          context.pop(true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 24),
                          const Spacer(),
                          AppButton.icon(
                            child: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocSelector<
                        NewTaskBloc,
                        NewTaskState,
                        ValidationModel<String>
                      >(
                        selector: (state) => state.taskTitle,
                        builder: (context, taskTitle) {
                          return AppFormField(
                            value: taskTitle.value,
                            errorText: taskTitle.error,
                            hintText: 'Write a new task...',
                            onChanged:
                                (value) => context.read<NewTaskBloc>().add(
                                  NewTaskEvent.updateTaskTitle(value),
                                ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppButton.primary(
                  title: 'Save',
                  onPressed:
                      () => context.read<NewTaskBloc>().add(
                        const NewTaskEvent.createTask(),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
