import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class MyTextButtonTheme {
  static final lightTextButton = TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: MyColors.darkPrimaryColor,
          textStyle: const TextStyle(
              color: MyColors.darkPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14)));
}
