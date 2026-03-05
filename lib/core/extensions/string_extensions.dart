extension StringExtension on String {
  // ── Validation ────────────────────────────────────────
  bool get isValidEmail => RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPhone => RegExp(r'^\+?[0-9]{9,15}$').hasMatch(this);

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;

  // ── Transform ─────────────────────────────────────────
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');

  String truncate(int maxLength, {String ellipsis = '...'}) =>
      length <= maxLength ? this : '${substring(0, maxLength)}$ellipsis';

  // ── Parsing ───────────────────────────────────────────
  int? toIntOrNull() => int.tryParse(this);

  double? toDoubleOrNull() => double.tryParse(this);
}

extension NullableStringExtension on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  String get orEmpty => this ?? '';
}
