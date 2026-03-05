import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/features/artist/artist_page.dart';
import 'package:flutter_clean_architecture/features/auth/register/register_page.dart';
import 'package:flutter_clean_architecture/features/auth/sign_in/sign_in_page.dart';
import 'package:flutter_clean_architecture/features/auth/welcome/welcome_page.dart';
import 'package:flutter_clean_architecture/features/home/home_page.dart';
import 'package:flutter_clean_architecture/features/log_console/log_console_page.dart';
import 'package:flutter_clean_architecture/features/onboarding/choose_mode/choose_mode_page.dart';
import 'package:flutter_clean_architecture/features/onboarding/get_started/get_started_page.dart';
import 'package:flutter_clean_architecture/features/player/lyrics/lyrics_page.dart';
import 'package:flutter_clean_architecture/features/player/music_player/music_player_page.dart';
import 'package:flutter_clean_architecture/features/profile/profile_page.dart';
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

    // Onboarding
    AutoRoute(
      page: GetStartedRoute.page,
      path: '/get-started',
      meta: const {
        'screenName': 'GetStarted',
        'screenCode': 'SCREEN-001',
      },
    ),
    AutoRoute(
      page: ChooseModeRoute.page,
      path: '/choose-mode',
      meta: const {
        'screenName': 'ChooseMode',
        'screenCode': 'SCREEN-002',
      },
    ),

    // Auth
    AutoRoute(
      page: WelcomeRoute.page,
      path: '/welcome',
      meta: const {
        'screenName': 'Welcome',
        'screenCode': 'SCREEN-003',
      },
    ),
    AutoRoute(
      page: SignInRoute.page,
      path: '/sign-in',
      meta: const {
        'screenName': 'SignIn',
        'screenCode': 'SCREEN-004',
      },
    ),
    AutoRoute(
      page: RegisterRoute.page,
      path: '/register',
      meta: const {
        'screenName': 'Register',
        'screenCode': 'SCREEN-005',
      },
    ),

    // Main
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      meta: const {
        'screenName': 'Home',
        'screenCode': 'SCREEN-006',
      },
    ),
    AutoRoute(
      page: ProfileRoute.page,
      path: '/profile',
      meta: const {
        'screenName': 'Profile',
        'screenCode': 'SCREEN-007',
      },
    ),

    // Discovery
    AutoRoute(
      page: ArtistRoute.page,
      path: '/artist/:id',
      meta: const {
        'screenName': 'Artist',
        'screenCode': 'SCREEN-008',
      },
    ),

    // Player
    AutoRoute(
      page: MusicPlayerRoute.page,
      path: '/player/:id',
      meta: const {
        'screenName': 'MusicPlayer',
        'screenCode': 'SCREEN-009',
      },
    ),
    AutoRoute(
      page: LyricsRoute.page,
      path: '/player/:id/lyrics',
      meta: const {
        'screenName': 'Lyrics',
        'screenCode': 'SCREEN-010',
      },
    ),
  ];
}