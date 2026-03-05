abstract interface class CrashlyticsService {
  Future<void> recordError(Object error, StackTrace? stack, {String? reason});
  Future<void> setUserId(String userId);
  Future<void> log(String message);
}
