extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;

  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }

  List<T> replaced(int index, T newItem) => [...sublist(0, index), newItem, ...sublist(index + 1)];

  List<T> replacedWhere(bool Function(T) test, T newItem) =>
      map((e) => test(e) ? newItem : e).toList();

  List<T> removedWhere(bool Function(T) test) => where((e) => !test(e)).toList();

  /// Split list into chunks of [size]
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }
}
