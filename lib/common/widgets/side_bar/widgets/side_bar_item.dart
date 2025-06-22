import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/side_bar/controllers/side_bar_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class SideBarItem extends StatelessWidget {
  const SideBarItem(
      {super.key,
      required this.route,
      required this.icon,
      required this.itemName});
  final String route;
  final IconData icon;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final sideBarController = Get.put(SideBarController());
    return InkWell(
      onTap: () => sideBarController.menuOnTap(route),
      onHover: (hovering) => hovering
          ? sideBarController.changeHoverItem(route)
          : sideBarController.changeHoverItem(''),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.only(
              top: MySizes.sm, left: MySizes.sm, right: MySizes.sm),
          child: Container(
            decoration: BoxDecoration(
                color: sideBarController.isHovering(route) ||
                        sideBarController.isActive(route)
                    ? MyColors.darkPrimaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(MySizes.borderRadiusMd)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: MySizes.lg,
                      right: MySizes.md,
                      top: MySizes.md,
                      bottom: MySizes.md),
                  child: Icon(
                    icon,
                    color: sideBarController.isHovering(route) ||
                            sideBarController.isActive(route)
                        ? Colors.white
                        : MyColors.darkPrimaryColor,
                  ),
                ),
                Text(
                  itemName,
                  style: Theme.of(context).textTheme.bodyLarge!.apply(
                      color: sideBarController.isHovering(route) ||
                              sideBarController.isActive(route)
                          ? Colors.white
                          : MyColors.darkPrimaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
