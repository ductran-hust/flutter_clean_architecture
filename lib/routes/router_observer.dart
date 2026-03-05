import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/utils/app_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RouterObserver extends AutoRouterObserver {
  RouterObserver() : super();

  bool _isDialog(Route<dynamic> route) => route is DialogRoute || route is PopupRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isDialog(route)) return;
    super.didPush(route, previousRoute);
    talker.logCustom(_TalkerRouteLog(route: route));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isDialog(route)) return;
    super.didPop(route, previousRoute);
    talker.logCustom(_TalkerRouteLog(route: route, isPush: false));
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isDialog(route)) return;
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null && _isDialog(newRoute)) return;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class _TalkerRouteLog extends TalkerLog {
  _TalkerRouteLog({required Route route, bool isPush = true})
    : super(_createMessage(route, isPush));

  @override
  AnsiPen get pen => AnsiPen()..xterm(135);

  @override
  String get key => TalkerKey.route;

  static String _createMessage(Route<dynamic> route, bool isPush) {
    final buffer = StringBuffer();
    buffer.write(isPush ? '→ Opened' : '← Closed');

    final routeData = route.data;
    if (routeData != null) {
      final screenName = routeData.meta['screenName'] as String? ?? routeData.name;
      final screenCode = routeData.meta['screenCode'] as String?;
      final path = routeData.path;

      if (screenCode != null) buffer.write(' [$screenCode]');
      buffer.write(' "$screenName" ($path)');
    } else {
      final routeName = route.settings.name;
      buffer.write(' ${routeName ?? route.runtimeType}');
    }

    return buffer.toString();
  }
}
