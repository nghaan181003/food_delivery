import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/responsive.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:food_delivery_h2d/common/widgets/responsive/screens/tablet_layout.dart';

class WebLayout extends StatelessWidget {
  final Widget body;

  const WebLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktop: DesktopLayout(body: body),
      tablet: TabletLayout(body: body),
      mobile: MobileLayout(body: body),
    );
  }
}
