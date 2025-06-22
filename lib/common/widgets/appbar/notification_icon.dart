import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/notification/controllers/notification_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class MyNotificationIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? iconColor;

  const MyNotificationIcon(
      {super.key, required this.onPressed, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    return Stack(
      children: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.notifications_on_outlined ,
              color: iconColor,
              size: 24,
            )),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                color: MyColors.darkPrimaryColor,
                borderRadius: BorderRadius.circular(100)),
            child: Center(
              child: Obx(() => Text(
                controller.countNotificationNotRead.toString(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(color: Colors.white),
              ),)
            ),
          ),
        )
      ],
    );
  }
}
