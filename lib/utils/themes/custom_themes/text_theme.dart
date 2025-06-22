import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class MyTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: MyColors.primaryTextColor),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: MyColors.primaryTextColor),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: MyColors.primaryTextColor),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MyColors.primaryTextColor),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: MyColors.primaryTextColor),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: MyColors.primaryTextColor),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: MyColors.primaryTextColor),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: MyColors.primaryTextColor),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: MyColors.secondaryTextColor),
    labelLarge: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: MyColors.primaryTextColor),
    labelSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: MyColors.secondaryTextColor),
  );
}
