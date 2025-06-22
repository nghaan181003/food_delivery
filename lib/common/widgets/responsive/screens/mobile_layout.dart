import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/web_header.dart';
import 'package:food_delivery_h2d/common/widgets/side_bar/side_bar.dart';

class MobileLayout extends StatelessWidget {
  MobileLayout({super.key, this.body});

  final Widget? body;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const SideBar(),
      appBar: WebHeader(scaffoldKey: scaffoldKey,),
      body: body ?? const SizedBox()
    );
  }
}
