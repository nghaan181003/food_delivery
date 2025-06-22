import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/web_header.dart';
import 'package:food_delivery_h2d/common/widgets/side_bar/side_bar.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;

  @override
  _DesktopLayoutState createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  bool isSidebarVisible = true; 

  void toggleSidebar() {
    setState(() {
      isSidebarVisible = !isSidebarVisible; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (isSidebarVisible) const Expanded(child: SideBar()),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                WebHeader(toggleDrawer: toggleSidebar), 
                Expanded(child: widget.body ?? const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
