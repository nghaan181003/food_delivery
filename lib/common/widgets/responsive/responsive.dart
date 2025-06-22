import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  final Widget tablet;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.desktop,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth >= MySizes.desktopScreenSize) {
        return desktop;
      } else if (constraints.maxWidth < MySizes.desktopScreenSize &&
          constraints.maxWidth >= MySizes.tabletScreenSize) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
