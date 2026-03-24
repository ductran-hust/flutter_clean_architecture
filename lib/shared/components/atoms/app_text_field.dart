import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.isPassword = false,
  });

  const AppTextField.password({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    bool enabled = true,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? errorText,
    String? helperText,
    bool autofocus = false,
  }) : this(
    key: key,
    label: label ?? 'Password',
    hint: hint ?? '••••••••',
    controller: controller,
    focusNode: focusNode,
    textInputAction: textInputAction,
    enabled: enabled,
    validator: validator,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    errorText: errorText,
    helperText: helperText,
    autofocus: autofocus,
    obscureText: true,
    isPassword: true,
    keyboardType: TextInputType.visiblePassword,
    autocorrect: false,
    enableSuggestions: false,
    prefixIcon: Icons.lock_outline,
  );

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final bool isPassword;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasError = widget.errorText != null;

    // ── Suffix icon ──────────────────────────────────────────────────────────
    Widget? suffix = widget.suffixIcon;
    if (widget.isPassword) {
      suffix = GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: colors.onSurfaceMuted,
        ),
      );
    }

    // ── Decoration ───────────────────────────────────────────────────────────
    // Chỉ khai báo những gì widget cần override.
    // applyDefaults() sẽ fill tất cả null fields từ InputDecorationTheme —
    // border, fillColor, contentPadding, hintStyle, v.v. đều được kế thừa.
    final decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      errorText: hasError ? widget.errorText : null,
      helperText: widget.helperText,
      counterText: '',
      // Chỉ override fillColor khi disabled — còn lại dùng từ theme
      fillColor: widget.enabled ? null : colors.surface.withOpacity(0.5),
      prefixIcon: widget.prefixIcon != null
          ? Icon(widget.prefixIcon, size: 20, color: colors.onSurfaceMuted)
          : null,
      suffixIcon: suffix != null
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: suffix,
      )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    ).applyDefaults(Theme.of(context).inputDecorationTheme);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscure,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: _obscure ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      textCapitalization: widget.textCapitalization,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: widget.enabled ? colors.onSurface : colors.onSurfaceMuted,
      ),
      decoration: decoration,
    );
  }
}