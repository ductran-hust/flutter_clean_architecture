import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/base/base_page.dart';
import 'package:flutter_clean_architecture/core/di/injection_container.dart';
import 'package:flutter_clean_architecture/core/extensions/datetime_extensions.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_form/todo_form_controller.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_form/todo_form_state.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_button.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_card.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_dialog.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_divider.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_status_tag.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_text_field.dart';

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
    final textStyles = context.appTextStyles;

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
                      style: textStyles.titleLarge.copyWith(
                        color: colors.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Save button — AppButton
                  AppButton(
                    label: LocaleKeys.todo_form_save.tr(),
                    onPressed: (!data.hasSubmitted || data.isValid)
                        ? () => _onSave(context, cubit)
                        : null,
                    size: AppButtonSize.small,
                    isFullWidth: false,
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
                  // Title field — AppTextField
                  AppTextField(
                    controller: _titleController,
                    focusNode: _titleFocus,
                    label: '${LocaleKeys.todo_form_titleLabel.tr()} *',
                    hint: LocaleKeys.todo_form_titleHint.tr(),
                    onChanged: cubit.updateTitle,
                    onSubmitted: (_) => _descFocus.requestFocus(),
                    textInputAction: TextInputAction.next,
                    errorText: data.titleError,
                    maxLength: TodoFormState.titleMaxLength,
                    helperText: '${data.titleCharCount}/${TodoFormState.titleMaxLength}',
                  ),
                  const SizedBox(height: 20),

                  // Description field — AppTextField
                  AppTextField(
                    controller: _descController,
                    focusNode: _descFocus,
                    label: LocaleKeys.todo_form_descLabel.tr(),
                    hint: LocaleKeys.todo_form_descHint.tr(),
                    onChanged: cubit.updateDescription,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    errorText: data.descriptionError,
                    maxLength: TodoFormState.descMaxLength,
                    helperText: '${data.descCharCount}/${TodoFormState.descMaxLength}',
                  ),

                  // ── Meta info (edit mode) ──
                  if (data.isEditMode) ...[
                    const SizedBox(height: 28),
                    const AppDivider(),

                    Text(
                      'Details',
                      style: textStyles.titleSmall.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // AppCard wrapping meta items
                    AppCard(
                      child: Column(
                        children: [
                          _MetaRow(
                            icon: Icons.calendar_today_rounded,
                            label: LocaleKeys.todo_form_createdAt.tr(),
                            value: data.initialTodo!.createdAt
                                .toFormatted(AppDateFormat.ddMMyyyyHHmm),
                            iconColor: colors.primary,
                          ),
                          if (data.initialTodo!.updatedAt != null) ...[
                            const AppDivider(height: 16),
                            _MetaRow(
                              icon: Icons.update_rounded,
                              label: 'Updated',
                              value: data.initialTodo!.updatedAt!
                                  .toFormatted(AppDateFormat.ddMMyyyyHHmm),
                              iconColor: colors.secondary,
                            ),
                          ],
                          const AppDivider(height: 16),
                          _StatusRow(todo: data.initialTodo!),
                        ],
                      ),
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
    final entity = cubit.validateAndBuild();
    if (entity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Please fix the errors before saving')),
            ],
          ),
          backgroundColor: context.appColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    context.router.pop(entity);
  }

  Future<void> _onCancel(BuildContext context, TodoFormState data) async {
    if (data.hasChanges) {
      // AppDialog.confirm
      final discard = await AppDialog.confirm(
        context,
        title: 'Discard Changes?',
        message: 'You have unsaved changes. Are you sure you want to go back?',
        confirmLabel: 'Discard',
        cancelLabel: 'Keep Editing',
        isDangerous: true,
      );
      if (!discard) return;
    }
    if (context.mounted) {
      await context.router.maybePop();
    }
  }
}

// ── Meta Row ──

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textStyles.labelSmall.copyWith(color: colors.onSurfaceMuted),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textStyles.titleSmall.copyWith(color: colors.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Status Row ──

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.todo});

  final TodoEntity todo;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    final statusColor = todo.isCompleted ? colors.success : colors.warning;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            todo.isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: statusColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.todo_form_status.tr(),
                style: textStyles.labelSmall.copyWith(color: colors.onSurfaceMuted),
              ),
              const SizedBox(height: 4),
              // AppStatusTag
              AppStatusTag(
                label: todo.isCompleted
                    ? LocaleKeys.todo_status_completed.tr()
                    : LocaleKeys.todo_status_active.tr(),
                type: todo.isCompleted
                    ? AppStatusTagType.success
                    : AppStatusTagType.warning,
                icon: todo.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
