import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/appbar.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/notification_icon.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/notification/views/notification_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/controllers/profile_restaurant_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class RestaurantHomeAppbar extends StatelessWidget {
  const RestaurantHomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileRestaurantController());
    return MyAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            final status = profileController.profile.isAvailable.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LoginController.instance.currentUser!.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .apply(color: Colors.white),
                ),
                const SizedBox(
                  height: MySizes.xs,
                ),
                Row(
                  children: [
                    Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: status
                                ? MyColors.openColor
                                : MyColors.greyWhite)),
                    const SizedBox(
                      width: MySizes.sm,
                    ),
                    Text(
                      status ? "Đang mở cửa" : "Đã đóng cửa",
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                          color:
                              status ? MyColors.openColor : MyColors.greyWhite),
                    ),
                  ],
                ),
              ],
            );
          })
        ],
      ),
      actions: [
        MyNotificationIcon(
          onPressed: () {
            Get.to(const NotificationScreen());
          },
        ),
      ],
    );
  }
}
