import 'package:flutter/material.dart';

extension NumExtension on num {
  // ── Spacing widgets ───────────────────────────────────
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  SizedBox get verticalSpace => SizedBox(height: toDouble());

  // ── EdgeInsets ────────────────────────────────────────
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  // ── Duration ──────────────────────────────────────────
  Duration get milliseconds => Duration(milliseconds: toInt());

  Duration get seconds => Duration(seconds: toInt());

  Duration get minutes => Duration(minutes: toInt());
}
