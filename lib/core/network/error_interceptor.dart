import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/utils/app_logger.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);
    AppLogger.e(
      '[ErrorInterceptor] ${err.requestOptions.method} ${err.requestOptions.path}',
      error: failure,
      stackTrace: err.stackTrace,
    );
    throw failure;
  }

  Failure _mapToFailure(DioException e) {
    if (_isNetworkError(e)) return NetworkFailure();
    final statusCode = e.response?.statusCode ?? 0;
    if (statusCode == 404) return NotFoundFailure();
    final message = e.response?.data?['message'] as String? ?? e.message ?? 'Server error';
    return ServerFailure(statusCode: statusCode, message: message);
  }

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout;
}
