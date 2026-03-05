import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/base/base_page.dart';
import 'package:flutter_clean_architecture/core/di/injection_container.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_form/todo_form_controller.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_form/todo_form_state.dart';

@RoutePage()
class TodoFormPage extends BasePage<TodoFormController, TodoFormState> {
  const TodoFormPage({super.key, this.initialTodo});

  final TodoEntity? initialTodo;

  @override
  TodoFormController createController() {
    return getIt<TodoFormController>(param1: initialTodo);
  }

  @override
  Widget builder(BuildContext context, TodoFormController cubit, TodoFormState data) {
    return _TodoFormView(controller: cubit, data: data);
  }
}

class _TodoFormView extends StatefulWidget {
  const _TodoFormView({required this.controller, required this.data});

  final TodoFormController controller;
  final TodoFormState data;

  @override
  State<_TodoFormView> createState() => _TodoFormViewState();
}

class _TodoFormViewState extends State<_TodoFormView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data.title);
    _descController = TextEditingController(text: widget.data.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe chỉ data để rebuild khi isValid thay đổi
    final data = context.watch<TodoFormController>().state.data;
    final cubit = widget.controller;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.isEditMode
              ? LocaleKeys.todo_form_editTitle.tr()
              : LocaleKeys.todo_form_createTitle.tr(),
        ),
        actions: [
          TextButton(
            onPressed: data.isValid ? () => _onSave(context, cubit) : null,
            child: Text(LocaleKeys.todo_form_save.tr()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: LocaleKeys.todo_form_titleLabel.tr(),
              hintText: LocaleKeys.todo_form_titleHint.tr(),
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onChanged: cubit.updateTitle,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: LocaleKeys.todo_form_descLabel.tr(),
              hintText: LocaleKeys.todo_form_descHint.tr(),
              border: const OutlineInputBorder(),
            ),
            maxLines: 4,
            onChanged: cubit.updateDescription,
          ),
          if (data.isEditMode) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            _MetaRow(
              icon: Icons.calendar_today,
              label: LocaleKeys.todo_form_createdAt.tr(),
              value: DateFormat.yMMMd().format(data.initialTodo!.createdAt),
            ),
            const SizedBox(height: 8),
            _MetaRow(
              icon: data.initialTodo!.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              label: LocaleKeys.todo_form_status.tr(),
              value: data.initialTodo!.isCompleted
                  ? LocaleKeys.todo_status_completed.tr()
                  : LocaleKeys.todo_status_active.tr(),
              valueColor: data.initialTodo!.isCompleted ? Colors.green : Colors.orange,
            ),
          ],
        ],
      ),
    );
  }

  void _onSave(BuildContext context, TodoFormController cubit) {
    final entity = cubit.buildEntity();
    context.router.pop(entity);
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label, required this.value, this.valueColor});

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(color: valueColor)),
      ],
    );
  }
}
