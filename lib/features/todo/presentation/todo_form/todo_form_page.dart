import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/base/base_page.dart';
import 'package:flutter_clean_architecture/core/di/injection_container.dart';
import 'package:flutter_clean_architecture/core/extensions/datetime_extensions.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
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
  late final FocusNode _titleFocus;
  late final FocusNode _descFocus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data.title);
    _descController = TextEditingController(text: widget.data.description);
    _titleFocus = FocusNode();
    _descFocus = FocusNode();

    // Auto focus title field on create
    if (!widget.data.isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<TodoFormController>().state.data;
    final cubit = widget.controller;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // Close button
                  GestureDetector(
                    onTap: () => _onCancel(context, data),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.grey200),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      data.isEditMode
                          ? LocaleKeys.todo_form_editTitle.tr()
                          : LocaleKeys.todo_form_createTitle.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                  // Save button
                  _SaveButton(
                    isEnabled: data.isValid,
                    onTap: () => _onSave(context, cubit),
                    colors: colors,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Form ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Title field
                  _FormField(
                    controller: _titleController,
                    focusNode: _titleFocus,
                    label: LocaleKeys.todo_form_titleLabel.tr(),
                    hint: LocaleKeys.todo_form_titleHint.tr(),
                    onChanged: cubit.updateTitle,
                    onSubmitted: (_) => _descFocus.requestFocus(),
                    textInputAction: TextInputAction.next,
                    colors: colors,
                    isRequired: true,
                    errorText: _titleController.text.isNotEmpty && !data.isValid
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Description field
                  _FormField(
                    controller: _descController,
                    focusNode: _descFocus,
                    label: LocaleKeys.todo_form_descLabel.tr(),
                    hint: LocaleKeys.todo_form_descHint.tr(),
                    onChanged: cubit.updateDescription,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    colors: colors,
                  ),

                  // ── Meta info (edit mode) ──
                  if (data.isEditMode) ...[
                    const SizedBox(height: 28),
                    _Divider(colors: colors),
                    const SizedBox(height: 20),

                    Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _MetaCard(
                      colors: colors,
                      items: [
                        _MetaItem(
                          icon: Icons.calendar_today_rounded,
                          label: LocaleKeys.todo_form_createdAt.tr(),
                          value: data.initialTodo!.createdAt.toFormatted(AppDateFormat.ddMMyyyyHHmm),
                          iconColor: colors.primary,
                        ),
                        if (data.initialTodo!.updatedAt != null)
                          _MetaItem(
                            icon: Icons.update_rounded,
                            label: 'Updated',
                            value: data.initialTodo!.updatedAt!.toFormatted(AppDateFormat.ddMMyyyyHHmm),
                            iconColor: colors.secondary,
                          ),
                        _MetaItem(
                          icon: data.initialTodo!.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          label: LocaleKeys.todo_form_status.tr(),
                          value: data.initialTodo!.isCompleted
                              ? LocaleKeys.todo_status_completed.tr()
                              : LocaleKeys.todo_status_active.tr(),
                          iconColor: data.initialTodo!.isCompleted
                              ? colors.success
                              : colors.warning,
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave(BuildContext context, TodoFormController cubit) {
    if (!cubit.state.data.isValid) return;
    final entity = cubit.buildEntity();
    context.router.pop(entity);
  }

  Future<void> _onCancel(BuildContext context, TodoFormState data) async {
    final hasChanges = data.title.isNotEmpty || data.description.isNotEmpty;
    if (hasChanges && !data.isEditMode) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('You have unsaved changes. Are you sure you want to go back?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      if (discard != true) return;
    }
    if (context.mounted) {
      await context.router.maybePop();
    }
  }
}

// ── Save Button ──

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isEnabled,
    required this.onTap,
    required this.colors,
  });

  final bool isEnabled;
  final VoidCallback onTap;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isEnabled ? colors.primary : colors.grey200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          LocaleKeys.todo_form_save.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isEnabled ? Colors.white : colors.onSurfaceMuted,
          ),
        ),
      ),
    );
  }
}

// ── Form Field ──

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.colors,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
    this.isRequired = false,
    this.errorText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final AppColors colors;
  final int maxLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool isRequired;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null ? colors.error : colors.grey200,
              width: errorText != null ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: textInputAction,
            maxLines: maxLines,
            style: TextStyle(fontSize: 15, color: colors.onSurface),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: colors.onSurfaceMuted, fontSize: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(fontSize: 12, color: colors.error),
          ),
        ],
      ],
    );
  }
}

// ── Divider ──

class _Divider extends StatelessWidget {
  const _Divider({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: colors.grey200,
    );
  }
}

// ── Meta Card ──

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.colors, required this.items});

  final AppColors colors;
  final List<_MetaItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.grey200),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              if (i > 0) ...[
                const SizedBox(height: 8),
                Container(height: 1, color: colors.grey200),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item.iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.icon, size: 16, color: item.iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurfaceMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.value,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MetaItem {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
}
