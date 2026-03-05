import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/utils/app_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class LogConsolePage extends StatelessWidget {
  const LogConsolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(talker: talker, appBarTitle: 'Log Console');
  }
}
