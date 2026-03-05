import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init(
  settings: TalkerSettings(),
  logger: TalkerLogger(settings: TalkerLoggerSettings(enableColors: false)),
);

class AppLogger {
  static void d(String message) {
    if (kDebugMode) talker.debug(message);
  }

  static void i(String message) {
    if (kDebugMode) talker.info(message);
  }

  static void w(String message, {Object? error}) {
    talker.warning(message, error);
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    talker.error(message, error, stackTrace);
  }
}
