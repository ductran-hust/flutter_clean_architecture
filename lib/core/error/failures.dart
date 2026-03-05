import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure — implements Exception so it can be thrown/caught directly.
/// Repository throws these, BaseController.launch() catches them.
sealed class Failure implements Exception {
  String get readableMessage;
}

@freezed
class ServerFailure extends Failure with _$ServerFailure {
  ServerFailure({required this.statusCode, required this.message});

  @override
  final int statusCode;
  @override
  final String message;

  @override
  String get readableMessage => message;
}

@freezed
class NetworkFailure extends Failure with _$NetworkFailure {
  NetworkFailure({this.message = 'No internet connection'});

  @override
  final String message;

  @override
  String get readableMessage => message;
}

@freezed
class CacheFailure extends Failure with _$CacheFailure {
  CacheFailure({this.message = 'Cache error'});

  @override
  final String message;

  @override
  String get readableMessage => message;
}

@freezed
class NotFoundFailure extends Failure with _$NotFoundFailure {
  NotFoundFailure({this.message = 'Not found'});

  @override
  final String message;

  @override
  String get readableMessage => message;
}

@freezed
class UnknownFailure extends Failure with _$UnknownFailure {
  UnknownFailure({this.message = 'Unknown error'});

  @override
  final String message;

  @override
  String get readableMessage => message;
}
