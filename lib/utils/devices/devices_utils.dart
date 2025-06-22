import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class MyDeviceUtils {
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isDesktopScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= MySizes.desktopScreenSize;
  static bool isTabletScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= MySizes.tabletScreenSize &&
      MediaQuery.of(context).size.width < MySizes.desktopScreenSize;
  static bool isMobileScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < MySizes.tabletScreenSize;
}
