import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class MobileWrapper extends StatefulWidget {
  final Widget body;
  final Widget? bottom;
  final Widget? floatingButton;
  final PreferredSizeWidget? appBar;

  const MobileWrapper({
    super.key,
    required this.body,
    this.floatingButton,
    this.bottom,
    this.appBar,
  });

  @override
  State<MobileWrapper> createState() => _MobileRetailCashierWrapperState();
}

class _MobileRetailCashierWrapperState extends State<MobileWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: MySizes.sm),
            child: widget.bottom,
          ),
        ),
        floatingActionButton: widget.floatingButton,
        backgroundColor: MyColors.greyWhite,
        body: widget.body,
        appBar: widget.appBar);
  }
}
