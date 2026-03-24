import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';

/// Dropdown field matching the Figma design — same visual style as AppTextField.
///
/// ```dart
/// AppDropdown<String>(
///   label: 'Category',
///   hint: 'Select category',
///   value: _selected,
///   items: const ['Work', 'Personal', 'Health'],
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    this.label,
    this.hint,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.itemBuilder,
    this.errorText,
    this.helperText,
  });

  final List<T> items;
  final T? value;
  final String? label;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final IconData? prefixIcon;

  /// Optional custom label builder for each item. Defaults to `item.toString()`.
  final String Function(T item)? itemBuilder;

  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DropdownButtonFormField<T>(
      value: value,
      validator: validator,
      onChanged: enabled ? onChanged : null,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colors.onSurfaceMuted,
        size: 20,
      ),
      dropdownColor: colors.surface,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        helperText: helperText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: colors.onSurfaceMuted)
            : null,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemBuilder?.call(item) ?? item.toString(),
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurface,
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}