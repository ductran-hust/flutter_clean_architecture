import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/utils/app_logger.dart';

enum _DialogType { success, error, warning, info }

class AppDialog {
  AppDialog._();

  static const _tag = 'AppDialog';

  // ── Alert Dialogs ─────────────────────────────────────

  static Future<void> success(
    BuildContext context, {
    required String message,
    String? title,
    String confirmLabel = 'OK',
  }) {
    AppLogger.i('[$_tag] success — ${title ?? 'Success'}: $message');
    return _showAlert(
      context,
      type: _DialogType.success,
      title: title ?? 'Success',
      message: message,
      confirmLabel: confirmLabel,
    );
  }

  static Future<void> error(
    BuildContext context, {
    required String message,
    String? title,
    String confirmLabel = 'OK',
  }) {
    AppLogger.e('[$_tag] error — ${title ?? 'Error'}: $message');
    return _showAlert(
      context,
      type: _DialogType.error,
      title: title ?? 'Error',
      message: message,
      confirmLabel: confirmLabel,
    );
  }

  static Future<void> warning(
    BuildContext context, {
    required String message,
    String? title,
    String confirmLabel = 'OK',
  }) {
    AppLogger.w('[$_tag] warning — ${title ?? 'Warning'}: $message');
    return _showAlert(
      context,
      type: _DialogType.warning,
      title: title ?? 'Warning',
      message: message,
      confirmLabel: confirmLabel,
    );
  }

  static Future<void> info(
    BuildContext context, {
    required String message,
    String? title,
    String confirmLabel = 'OK',
  }) {
    AppLogger.i('[$_tag] info — ${title ?? 'Info'}: $message');
    return _showAlert(
      context,
      type: _DialogType.info,
      title: title ?? 'Info',
      message: message,
      confirmLabel: confirmLabel,
    );
  }

  // ── Confirm Dialog ────────────────────────────────────

  static Future<bool> confirm(
    BuildContext context, {
    required String message,
    String? title,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
  }) async {
    AppLogger.i('[$_tag] confirm — ${title ?? 'Confirm'}: $message');
    final scheme = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _AppDialogWidget(
        icon: isDangerous ? Icons.warning_amber_rounded : Icons.help_outline,
        iconColor: isDangerous ? scheme.error : scheme.primary,
        title: title ?? 'Confirm',
        message: message,
        actions: [
          _DialogAction(
            label: cancelLabel,
            onTap: () => Navigator.of(ctx).pop(false),
            isOutlined: true,
          ),
          _DialogAction(
            label: confirmLabel,
            onTap: () => Navigator.of(ctx).pop(true),
            color: isDangerous ? scheme.error : scheme.primary,
          ),
        ],
      ),
    );
    final confirmed = result ?? false;
    AppLogger.i('[$_tag] confirm result — $confirmed');
    return confirmed;
  }

  // ── Input Dialog ──────────────────────────────────────

  static Future<String?> input(
    BuildContext context, {
    required String title,
    String? hint,
    String? initialValue,
    String confirmLabel = 'OK',
    String cancelLabel = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) async {
    AppLogger.i('[$_tag] input — $title');
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => _AppDialogWidget(
        icon: Icons.edit_outlined,
        iconColor: Theme.of(context).colorScheme.primary,
        title: title,
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: keyboardType,
            decoration: InputDecoration(hintText: hint),
            validator: validator,
          ),
        ),
        actions: [
          _DialogAction(label: cancelLabel, onTap: () => Navigator.of(ctx).pop(), isOutlined: true),
          _DialogAction(
            label: confirmLabel,
            onTap: () {
              if (formKey.currentState?.validate() ?? true) {
                Navigator.of(ctx).pop(controller.text);
              }
            },
          ),
        ],
      ),
    );

    controller.dispose();
    AppLogger.i('[$_tag] input result — ${result != null ? '"$result"' : 'cancelled'}');
    return result;
  }

  // ── Loading Dialog ────────────────────────────────────

  static void showLoading(BuildContext context, {String? message}) {
    AppLogger.i('[$_tag] showLoading${message != null ? ' — $message' : ''}');
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (message != null) ...[const SizedBox(height: 16), Text(message)],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    AppLogger.i('[$_tag] hideLoading');
    Navigator.of(context, rootNavigator: true).pop();
  }

  // ── Internal ──────────────────────────────────────────

  static Future<void> _showAlert(
    BuildContext context, {
    required _DialogType type,
    required String title,
    required String message,
    required String confirmLabel,
  }) {
    final color = _colorOf(context, type);
    return showDialog<void>(
      context: context,
      builder: (ctx) => _AppDialogWidget(
        icon: _iconOf(type),
        iconColor: color,
        title: title,
        message: message,
        actions: [
          _DialogAction(label: confirmLabel, onTap: () => Navigator.of(ctx).pop(), color: color),
        ],
      ),
    );
  }

  static IconData _iconOf(_DialogType type) => switch (type) {
    _DialogType.success => Icons.check_circle_outline,
    _DialogType.error => Icons.error_outline,
    _DialogType.warning => Icons.warning_amber_rounded,
    _DialogType.info => Icons.info_outline,
  };

  static Color _colorOf(BuildContext context, _DialogType type) {
    final scheme = Theme.of(context).colorScheme;
    return switch (type) {
      _DialogType.success => Colors.green,
      _DialogType.error => scheme.error,
      _DialogType.warning => Colors.orange,
      _DialogType.info => scheme.primary,
    };
  }
}

// ── Internal Widgets ──────────────────────────────────

class _AppDialogWidget extends StatelessWidget {
  const _AppDialogWidget({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.message,
    this.content,
    required this.actions,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? message;
  final Widget? content;
  final List<_DialogAction> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title, style: textTheme.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            if (content != null) ...[const SizedBox(height: 16), content!],
            const SizedBox(height: 24),
            Row(
              spacing: 12,
              children: actions
                  .map((a) => Expanded(child: _buildActionButton(context, a)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, _DialogAction action) {
    final color = action.color ?? Theme.of(context).colorScheme.primary;
    if (action.isOutlined) {
      return OutlinedButton(
        onPressed: action.onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          foregroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(action.label),
      );
    }
    return ElevatedButton(
      onPressed: action.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(action.label),
    );
  }
}

class _DialogAction {
  const _DialogAction({
    required this.label,
    required this.onTap,
    this.color,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool isOutlined;
}
