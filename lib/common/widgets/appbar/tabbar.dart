import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/devices/devices_utils.dart';

class MyTabbar extends StatelessWidget implements PreferredSizeWidget {
  const MyTabbar({
    super.key,
    this.onTap,
    required this.tabs,
    required this.controller,
    this.isReadOnly = true,
  });

  final ValueChanged<int>? onTap;
  final List<Widget> tabs;
  final TabController controller;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isReadOnly,
      child: Material(
        color: Colors.white,
        child: TabBar(
          controller: controller,
          labelPadding: const EdgeInsets.all(0),
          onTap: onTap,
          tabs: List.generate(tabs.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: tabs[index],
            );
          }),
          isScrollable: true,
          indicatorColor: MyColors.primaryColor,
          labelColor: MyColors.primaryColor,
          unselectedLabelColor: MyColors.primaryTextColor,
          tabAlignment: TabAlignment.start,
          dividerColor: MyColors.dividerColor,
          overlayColor: const WidgetStatePropertyAll(Colors.white),
          labelStyle: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MyDeviceUtils.getAppBarHeight());
}
