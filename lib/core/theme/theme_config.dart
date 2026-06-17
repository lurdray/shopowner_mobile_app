import 'package:flutter/material.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';

ThemeData darkTheme = ThemeData.dark();
ThemeData lightTheme = ThemeData.light();

ThemeData appDarkTheme = darkTheme.copyWith(
  textTheme: darkTheme.textTheme.apply(
    fontFamily: generalFontFam,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.secClr,
    iconTheme: IconThemeData(color: Colors.white70),
  ),
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
  ),
);

ThemeData appLightTheme = lightTheme.copyWith(
  textTheme: lightTheme.textTheme.apply(
    fontFamily: generalFontFam,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.secClr,
    iconTheme: IconThemeData(color: Colors.black87),
  ),
  primaryColor: Colors.white,
  scaffoldBackgroundColor: AppColors.secClr,
  primaryColorLight: AppColors.primaryClr,
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.primaryClr,
  ),
);
