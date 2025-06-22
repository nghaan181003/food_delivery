import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/rating/controllers/driver_rating_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/devices/devices_utils.dart';
import 'package:get/get.dart';

class DriverRatingTabbar extends StatelessWidget implements PreferredSizeWidget {
  const DriverRatingTabbar({super.key, this.onTap, required this.tabs});

  final ValueChanged<int>? onTap;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.primaryBackgroundColor,
      child: TabBar(
        labelPadding: const EdgeInsets.only(left: MySizes.spaceBtwItems/2),
        onTap: onTap,
        tabs: tabs,
        isScrollable: true,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        tabAlignment: TabAlignment.start,
        dividerColor: MyColors.primaryBackgroundColor,
        padding: const EdgeInsets.only(top: MySizes.xs, bottom: MySizes.md),
        overlayColor: const WidgetStatePropertyAll(Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MyDeviceUtils.getAppBarHeight() * 3);
}

class DriverTabbar extends StatelessWidget {
  const DriverTabbar({super.key, required this.value, required this.label, this.icon});

  final int value;
  final String label;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Obx(() {
        final isSelected = DriverRatingController.instance.selectedFilter.value == value;
        return Container(
          width: 80,
          decoration: BoxDecoration(
            color: isSelected ? MyColors.darkPrimaryColor : Colors.white,
            border: Border.all(
              color: isSelected ? MyColors.darkPrimaryColor : MyColors.darkPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold,color: isSelected ? Colors.white : MyColors.darkPrimaryColor,),
                ),
                if (icon != null) 
                  Padding(
                    padding: const EdgeInsets.only(left: MySizes.spaceBtwItems/2), 
                    child: icon,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
