// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:injectable/injectable.dart';
// import 'analytics_service.dart';
//
// @LazySingleton(as: AnalyticsService)
// class FirebaseAnalyticsService implements AnalyticsService {
//   FirebaseAnalyticsService() : _analytics = FirebaseAnalytics.instance;
//
//   final FirebaseAnalytics _analytics;
//
//   @override
//   Future<void> logEvent(String name, {Map<String, dynamic>? params}) =>
//       _analytics.logEvent(name: name, parameters: params);
//
//   @override
//   Future<void> setUserId(String? userId) =>
//       _analytics.setUserId(id: userId);
//
//   @override
//   Future<void> setUserProperty(String name, String? value) =>
//       _analytics.setUserProperty(name: name, value: value);
//
//   @override
//   Future<void> logScreenView(String screenName) =>
//       _analytics.logScreenView(screenName: screenName);
// }
