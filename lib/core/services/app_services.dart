// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/core/utils/app_logger.dart';

abstract final class AppServices {
  static Future<void> initialize() async {
    // await Firebase.initializeApp();
    // _setupCrashlytics();
    // await _setupNotification();
    AppLogger.i('[AppServices] initialized');
  }

  // static void _setupCrashlytics() {
  //   // Catch Flutter framework errors
  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //   // Catch async errors outside Flutter framework
  //   PlatformDispatcher.instance.onError = (error, stack) {
  //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //     return true;
  //   };
  // }

  // static Future<void> _setupNotification() async {
  //   final notification = getIt<NotificationService>();
  //   await notification.initialize();
  //   await notification.requestPermission();
  // }
}
