import 'package:flutter/material.dart';

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.direction = Axis.vertical,
  });

  final T value;
  final List<AppRadioItem<T>> items;
  final ValueChanged<T> onChanged;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final children = items
        .map(
          (item) => GestureDetector(
            onTap: () => onChanged(item.value),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Radio<T>(
                    value: item.value,
                    groupValue: value,
                    onChanged: (v) => v != null ? onChanged(v) : null,
                    activeColor: scheme.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: 8),
                Text(item.label, style: textTheme.bodyMedium),
              ],
            ),
          ),
        )
        .toList();

    return direction == Axis.vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .expand((w) => [w, const SizedBox(height: 8)])
                .toList()
              ..removeLast(),
          )
        : Row(
            children: children
                .expand((w) => [w, const SizedBox(width: 16)])
                .toList()
              ..removeLast(),
          );
  }
}

class AppRadioItem<T> {
  const AppRadioItem({required this.label, required this.value});

  final String label;
  final T value;
}
