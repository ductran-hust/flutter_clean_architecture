import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/network/error_interceptor.dart';
import 'package:flutter_clean_architecture/core/network/logging_interceptor.dart';
import 'package:flutter_clean_architecture/core/network/mock_interceptor.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([MockInterceptor(), LoggingInterceptor(), ErrorInterceptor()]);

    return dio;
  }
}
