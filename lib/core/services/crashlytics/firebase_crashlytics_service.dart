// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:injectable/injectable.dart';
// import 'crashlytics_service.dart';
//
// @LazySingleton(as: CrashlyticsService)
// class FirebaseCrashlyticsService implements CrashlyticsService {
//   FirebaseCrashlyticsService() : _crashlytics = FirebaseCrashlytics.instance;
//
//   final FirebaseCrashlytics _crashlytics;
//
//   @override
//   Future<void> recordError(Object error, StackTrace? stack, {String? reason}) =>
//       _crashlytics.recordError(error, stack, reason: reason);
//
//   @override
//   Future<void> setUserId(String userId) =>
//       _crashlytics.setUserIdentifier(userId);
//
//   @override
//   Future<void> log(String message) => _crashlytics.log(message);
// }
