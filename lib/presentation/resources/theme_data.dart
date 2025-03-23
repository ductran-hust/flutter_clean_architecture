import 'package:flutter/material.dart';

class AppThemeData {
  AppThemeData({
    this.textTheme,
    this.colorSchema,
  });

  final AppTextTheme? textTheme;
  final AppColorSchema? colorSchema;
}

class AppTextTheme {
  AppTextTheme({
    this.h1,
    this.h2,
    this.h3,
    this.primary,
    this.medium,
    this.small,
    this.highlightsMedium,
    this.highlightsBold,
    this.button,
    this.title,
    this.header,
    this.title2,
    this.title3,
  });

  final TextStyle? h1;
  final TextStyle? h2;
  final TextStyle? h3;
  final TextStyle? primary;
  final TextStyle? medium;
  final TextStyle? small;
  final TextStyle? highlightsMedium;
  final TextStyle? highlightsBold;
  final TextStyle? button;
  final TextStyle? title;
  final TextStyle? header;
  final TextStyle? title2;
  final TextStyle? title3;
}

class AppColorSchema {
  AppColorSchema({
    this.primary,
    this.mainText,
    this.subText,
    this.whiteText,
    this.disableText,
    this.border,
    this.background,
    this.barrierColor,
    this.secondary1,
    this.secondary2,
    this.secondary3,
    this.secondary4,
    this.badgeColor,
    this.title2,
  });

  final Color? primary;
  final Color? mainText;
  final Color? subText;
  final Color? whiteText;
  final Color? disableText;
  final Color? secondary1;
  final Color? secondary2;
  final Color? secondary3;
  final Color? secondary4;
  final Color? border;
  final Color? background;
  final Color? barrierColor;
  final Color? badgeColor;
  final Color? title2;
}
