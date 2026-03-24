import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/themes.dart';
import 'package:flutter_clean_architecture/routes/app_router.dart';
import 'package:flutter_clean_architecture/routes/router_observer.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Base Clean Architecture',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: _router.config(navigatorObservers: () => [RouterObserver()]),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}