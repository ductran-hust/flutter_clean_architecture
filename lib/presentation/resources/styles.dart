import 'package:flutter/cupertino.dart';

import '../../gen/fonts.gen.dart';

abstract class AppStyles {
  static const h1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 32,
    height: 32 / 32,
    fontFamily: FontFamily.googleSans,
  );
  static const h2 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 32 / 24,
    fontFamily: FontFamily.googleSans,
  );
  static const h3 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 18 / 16,
    fontFamily: FontFamily.googleSans,
  );
  static const primary = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 18 / 13,
    fontFamily: FontFamily.googleSans,
  );
  static const medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24 / 16,
    fontFamily: FontFamily.googleSans,
  );
  static const small = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 18 / 12,
    fontFamily: FontFamily.googleSans,
  );
  static const highlightsMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 18 / 13,
    fontFamily: FontFamily.googleSans,
  );
  static const highlightsBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 24 / 14,
    fontFamily: FontFamily.googleSans,
  );
  static const button = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 13,
    height: 18 / 13,
    fontFamily: FontFamily.googleSans,
  );
  static const title = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 18 / 16,
    fontFamily: FontFamily.googleSans,
  );
  static const header = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 28 / 18,
    fontFamily: FontFamily.googleSans,
  );
  static const bottomNavigation = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 16 / 11,
    fontFamily: FontFamily.googleSans,
  );
}