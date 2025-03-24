import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/task.dart';
import '../view/pages/home/home_page.dart';
import '../view/pages/new_task/new_task_page.dart';
import '../view/pages/task_detail/task_detail_page.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Dialog|Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: NewTaskRoute.page),
    AutoRoute(page: TaskDetailRoute.page),
  ];
}