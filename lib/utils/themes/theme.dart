import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/themes/custom_themes/app_bar_theme.dart';
import 'package:food_delivery_h2d/utils/themes/custom_themes/elevated_button_theme.dart';
import 'package:food_delivery_h2d/utils/themes/custom_themes/outline_button_theme.dart';
import 'package:food_delivery_h2d/utils/themes/custom_themes/text_button_theme.dart';
import 'package:food_delivery_h2d/utils/themes/custom_themes/text_field_theme.dart';
import 'package:food_delivery_h2d/utils/themes/custom_themes/text_theme.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(
          primary: MyColors.primaryColor,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: MyColors.primaryTextColor,
          secondary: MyColors.lightPrimaryColor),
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      appBarTheme: MyAppBarTheme.lightAppBarTheme,
      textTheme: MyTextTheme.lightTextTheme,
      elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
      textButtonTheme: MyTextButtonTheme.lightTextButton,
      inputDecorationTheme: MyTextFieldTheme.lightInputDecorationTheme,
      textSelectionTheme: MyTextFieldTheme.lightTextSelectionTheme,
      outlinedButtonTheme: MyOutlineButtonTheme.lightOutlineButtonTheme);
}
