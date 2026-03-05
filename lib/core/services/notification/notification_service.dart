abstract interface class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Stream<NotificationPayload> get onMessage;
  Stream<NotificationPayload> get onMessageOpenedApp;
}

class NotificationPayload {
  const NotificationPayload({required this.title, required this.body, this.data = const {}});

  final String title;
  final String body;
  final Map<String, dynamic> data;
}
