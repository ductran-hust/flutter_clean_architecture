// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:injectable/injectable.dart';
// import 'notification_service.dart';
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
//
// @LazySingleton(as: NotificationService)
// class FirebaseNotificationService implements NotificationService {
//   FirebaseNotificationService() : _messaging = FirebaseMessaging.instance;
//
//   final FirebaseMessaging _messaging;
//   final _onMessageController = StreamController<NotificationPayload>.broadcast();
//   final _onMessageOpenedAppController = StreamController<NotificationPayload>.broadcast();
//
//   @override
//   Future<void> initialize() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessage.listen((m) => _onMessageController.add(_toPayload(m)));
//     FirebaseMessaging.onMessageOpenedApp.listen((m) => _onMessageOpenedAppController.add(_toPayload(m)));
//   }
//
//   @override
//   Future<bool> requestPermission() async {
//     final settings = await _messaging.requestPermission();
//     return settings.authorizationStatus == AuthorizationStatus.authorized;
//   }
//
//   @override
//   Future<String?> getToken() => _messaging.getToken();
//
//   @override
//   Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);
//
//   @override
//   Future<void> unsubscribeFromTopic(String topic) => _messaging.unsubscribeFromTopic(topic);
//
//   @override
//   Stream<NotificationPayload> get onMessage => _onMessageController.stream;
//
//   @override
//   Stream<NotificationPayload> get onMessageOpenedApp => _onMessageOpenedAppController.stream;
//
//   NotificationPayload _toPayload(RemoteMessage m) => NotificationPayload(
//     title: m.notification?.title ?? '',
//     body: m.notification?.body ?? '',
//     data: m.data,
//   );
// }
