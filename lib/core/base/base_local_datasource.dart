import 'package:hive_ce/hive.dart';

/// Model phải implement interface này để BaseLocalDataSource hoạt động
abstract interface class HiveModel {
  String get id;
  Map<String, dynamic> toJson();
}

abstract class BaseLocalDataSource<T extends HiveModel> {
  const BaseLocalDataSource(this.box);

  final Box<dynamic> box;

  /// Subclass cung cấp cách parse từ JSON → T
  T fromJson(Map<String, dynamic> json);

  // ── CRUD ──────────────────────────────────────────────

  Future<List<T>> getAll() async {
    return box.values.whereType<Map>().map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<T?> getById(String id) async {
    final raw = box.get(id);
    if (raw == null) return null;
    return fromJson(Map<String, dynamic>.from(raw as Map));
  }

  Future<void> save(T item) async {
    await box.put(item.id, item.toJson());
  }

  Future<void> saveAll(List<T> items) async {
    for (final item in items) {
      await box.put(item.id, item.toJson());
    }
  }

  Future<void> delete(String id) async {
    await box.delete(id);
  }

  Future<void> deleteAll(List<String> ids) async {
    await box.deleteAll(ids);
  }

  Future<void> clear() async {
    await box.clear();
  }

  Future<bool> exists(String id) async {
    return box.containsKey(id);
  }

  Future<int> count() async {
    return box.length;
  }
}
