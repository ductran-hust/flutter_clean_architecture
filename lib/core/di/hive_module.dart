import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract class HiveBoxNames {
  static const String todos = 'todos';
}

@module
abstract class HiveModule {
  @Named(HiveBoxNames.todos)
  @singleton
  Box<dynamic> todoBox() => Hive.box<dynamic>(HiveBoxNames.todos);
}
