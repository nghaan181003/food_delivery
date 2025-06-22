import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/devices/devices_utils.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final VoidCallback? handleBack;
  final Color? iconColor;
  final double? appBarHeight; 

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = true,
    this.iconColor = Colors.white,
    this.handleBack,
    this.appBarHeight, 
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyColors.darkPrimaryColor,
      centerTitle: true,
      titleSpacing: 0,
      leading: showBackArrow
          ? IconButton(
              onPressed: handleBack ?? () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: iconColor,
                size: MySizes.iconMs,
              ))
          : leadingIcon != null
              ? IconButton(
                  onPressed: leadingOnPressed,
                  icon: Icon(leadingIcon, color: iconColor))
              : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      appBarHeight ?? MyDeviceUtils.getAppBarHeight()); 
}
