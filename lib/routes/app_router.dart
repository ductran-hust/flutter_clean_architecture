import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/features/log_console/log_console_page.dart';
import 'package:flutter_clean_architecture/features/screen_list/screen_list_page.dart';
import 'package:flutter_clean_architecture/features/screen_list/widget_catalog_page.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_form/todo_form_page.dart';
import 'package:flutter_clean_architecture/features/todo/presentation/todo_list/todo_list_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Debug
    if (kDebugMode)
      ...[
        AutoRoute(
          page: ScreenListRoute.page,
          path: '/screen-list',
          initial: true,
          meta: const {
            'screenName': 'ScreenList',
            'screenCode': 'DBG-001',
          },
        ),
        AutoRoute(
          page: WidgetCatalogRoute.page,
          path: '/widget-catalog',
          meta: const {
            'screenName': 'WidgetCatalog',
            'screenCode': 'DBG-002',
          },
        ),
        AutoRoute(
          page: LogConsoleRoute.page,
          path: '/debug/log-console',
          meta: const {
            'screenName': 'LogConsole',
            'screenCode': 'DBG-003',
          },
        ),
        AutoRoute(
          page: TodoListRoute.page,
          path: '/debug/todos',
          meta: const {
            'screenName': 'TodoList',
            'screenCode': 'DBG-004',
          },
        ),
        AutoRoute(
          page: TodoFormRoute.page,
          path: '/debug/todos/form',
          meta: const {
            'screenName': 'TodoForm',
            'screenCode': 'DBG-005',
          },
        ),
      ],
  ];
}