import 'package:flutter_clean_architecture/core/utils/app_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';

class LoggingInterceptor extends TalkerDioLogger {
  LoggingInterceptor() : super(talker: talker);
}
