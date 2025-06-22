import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/responsive.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/screens/tablet_layout.dart';

class MySiteLayout extends StatelessWidget {
  const MySiteLayout({
    super.key,
    this.mobile,
    this.desktop,
    this.tablet,
    this.useLayout = true,
  });
  final Widget? mobile;
  final Widget? desktop;
  final Widget? tablet;
  final bool useLayout;
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktop: useLayout
          ? DesktopLayout(
              body: desktop,
            )
          : desktop ?? Container(),
      tablet: useLayout
          ? TabletLayout(
              body: tablet ?? desktop,
            )
          : tablet ?? desktop ?? Container(),
      mobile: useLayout
          ? MobileLayout(
              body: mobile ?? desktop,
            )
          : mobile ?? desktop ?? Container(),
    );
  }
}
