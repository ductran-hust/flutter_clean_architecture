import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/localization/locale_keys.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_dialog.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_status_tag.dart';

class TodoItemTile extends StatelessWidget {
  const TodoItemTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final TodoEntity todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    final isDone = todo.isCompleted;
    final timeAgo = _formatTimeAgo(todo.createdAt);

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: colors.error, size: 28),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone ? colors.success.withValues(alpha: 0.3) : colors.grey200,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.grey300.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ── Animated Checkbox ──
                  _AnimatedCheckbox(
                    isChecked: isDone,
                    onToggle: onToggle,
                    activeColor: colors.success,
                    inactiveColor: colors.grey500,
                  ),
                  const SizedBox(width: 14),

                  // ── Content ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: textStyles.titleSmall.copyWith(
                            fontSize: 15,
                            decoration:
                                isDone ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isDone ? colors.onSurfaceMuted : colors.onSurface,
                            decorationColor: colors.onSurfaceMuted,
                          ),
                          child: Text(todo.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        if (todo.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            todo.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyles.bodySmall.copyWith(color: colors.onSurfaceMuted),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 12, color: colors.grey500),
                            const SizedBox(width: 4),
                            Text(
                              timeAgo,
                              style: textStyles.labelSmall.copyWith(color: colors.grey500),
                            ),
                            if (isDone) ...[
                              const SizedBox(width: 8),
                              // AppStatusTag
                              AppStatusTag(
                                label: LocaleKeys.todo_status_completed.tr(),
                                type: AppStatusTagType.success,
                                icon: Icons.check_rounded,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── More button ──
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                        case 'delete':
                          _confirmAndDelete(context);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: _PopupItem(Icons.edit_outlined, 'Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: _PopupItem(Icons.delete_outline, 'Delete', color: colors.error),
                      ),
                    ],
                    icon: Icon(Icons.more_vert, size: 20, color: colors.grey500),
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // AppDialog.confirm
  Future<bool> _confirmDelete(BuildContext context) async {
    return AppDialog.confirm(
      context,
      title: 'Delete Todo',
      message: 'Are you sure you want to delete "${todo.title}"?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDangerous: true,
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed) onDelete();
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

class _AnimatedCheckbox extends StatelessWidget {
  const _AnimatedCheckbox({
    required this.isChecked,
    required this.onToggle,
    required this.activeColor,
    required this.inactiveColor,
  });

  final bool isChecked;
  final VoidCallback onToggle;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isChecked ? activeColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isChecked ? activeColor : inactiveColor,
            width: 2,
          ),
        ),
        child: isChecked
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}

class _PopupItem extends StatelessWidget {
  const _PopupItem(this.icon, this.label, {this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
