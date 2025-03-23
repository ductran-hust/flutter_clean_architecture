import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/gen/fonts.gen.dart';
import 'package:flutter_clean_architecture/presentation/resources/styles.dart';
import 'package:flutter_clean_architecture/shared/extension/theme_data.dart';

import 'colors.dart';
import 'theme_data.dart';

const kDefaultPaddingLabelTabBar = 8.0;

abstract class AppTheme {
  static final InputBorder _defaultOutlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.pattensBlue, width: 1),
    borderRadius: BorderRadius.circular(12),
  );

  static const _dividerTheme = DividerThemeData(
    space: 0,
    thickness: 1,
    color: AppColors.pattensBlue,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: FontFamily.googleSans,
      useMaterial3: false,
      appBarTheme: AppBarTheme(
        color: AppColors.white,
        titleTextStyle: AppStyles.title.copyWith(color: AppColors.nightRider),
        shadowColor: AppColors.gray20,
        elevation: 20,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: MaterialStateProperty.all(6.0),
        radius: const Radius.circular(3),
        minThumbLength: 90,
        thumbColor: MaterialStateProperty.all(AppColors.pattensBlue),
      ),
      colorScheme: const ColorScheme.light(
        background: AppColors.white,
        primary: AppColors.denim,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: _defaultOutlineInputBorder,
        focusedErrorBorder: _defaultOutlineInputBorder,
        errorBorder: _defaultOutlineInputBorder,
        disabledBorder: _defaultOutlineInputBorder,
        enabledBorder: _defaultOutlineInputBorder,
        focusedBorder: _defaultOutlineInputBorder,
        hintStyle: AppStyles.primary.copyWith(color: AppColors.nobel),
        labelStyle: AppStyles.primary.copyWith(color: AppColors.nightRider),
        errorStyle: AppStyles.primary.copyWith(color: AppColors.sunsetOrange),
        suffixStyle: AppStyles.primary.copyWith(color: AppColors.nobel),
        iconColor: AppColors.atlantis,
        suffixIconColor: AppColors.atlantis,
        prefixIconColor: AppColors.atlantis,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        isDense: true,
        filled: true,
      ),
      scaffoldBackgroundColor: AppColors.background,
      iconTheme: const IconThemeData(color: AppColors.atlantis),
      primaryIconTheme: const IconThemeData(color: AppColors.atlantis),
      dividerTheme: _dividerTheme,
      indicatorColor: AppColors.denim,
      tabBarTheme: TabBarTheme(
        labelStyle: AppStyles.highlightsBold,
        unselectedLabelStyle: AppStyles.highlightsBold.copyWith(
          fontWeight: FontWeight.normal,
        ),
        labelColor: AppColors.denim,
        unselectedLabelColor: AppColors.atlantis,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: kDefaultPaddingLabelTabBar,
        ),
      ),
    )..addOwn(
        Brightness.light,
        AppThemeData(
          textTheme: AppTextTheme(
            h1: AppStyles.h1,
            h2: AppStyles.h2,
            h3: AppStyles.h3,
            primary: AppStyles.primary,
            medium: AppStyles.medium,
            small: AppStyles.small,
            highlightsMedium: AppStyles.highlightsMedium,
            highlightsBold: AppStyles.highlightsBold,
            button: AppStyles.button,
            title: AppStyles.title,
            header: AppStyles.header,
          ),
          colorSchema: AppColorSchema(
            primary: AppColors.denim,
            mainText: AppColors.nightRider,
            subText: AppColors.atlantis,
            whiteText: AppColors.white,
            disableText: AppColors.nobel,
            border: AppColors.pattensBlue,
            background: AppColors.white,
            secondary1: AppColors.pigmentGreen,
            secondary2: AppColors.sunsetOrange,
            secondary3: AppColors.supernova,
            secondary4: AppColors.gorse,
            barrierColor: AppColors.black80,
            badgeColor: AppColors.coralRed,
            title2: AppColors.gray76,
          ),
        ),
      );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith()..addOwn(Brightness.dark, lightTheme.own());
  }
}