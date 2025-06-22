import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_delivery_h2d/features/notification/controllers/notification_controller.dart';
import 'package:food_delivery_h2d/features/notification/models/notification_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class NotificationsTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationsTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(notification.title),
            content: Text(notification.content),
            actions: [
              TextButton(
                onPressed: () {
                  notificationController.markAsRead(notification.id);
                  notification.isRead.value = true;
                  Navigator.of(context).pop();
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(MySizes.sm),
        child: Slidable(
            endActionPane: ActionPane(motion: const DrawerMotion(), children: [
              SlidableAction(
                onPressed: ((context) {
                  notificationController.deleteNotification(notification.id);
                }),
                backgroundColor: MyColors.errorColor,
                icon: Icons.delete,
                padding: const EdgeInsets.all(MySizes.md),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(MySizes.cardRadiusMd),
                    bottomRight: Radius.circular(MySizes.cardRadiusMd)),
              )
            ]),
            child: Obx(
              () => Container(
                padding: const EdgeInsets.all(MySizes.md),
                decoration: BoxDecoration(
                  color:
                      notification.isRead.value ? Colors.white : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: MyColors.primaryTextColor,
                                    fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: MySizes.sm),
                          Text(
                            notification.content,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: MyColors.primaryTextColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: MySizes.sm),
                          Row(
                            children: [
                              Text(
                                MyFormatter.formatTime(
                                    notification.sentAt.toString()),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(color: MyColors.secondaryTextColor),
                              ),
                              const SizedBox(
                                width: MySizes.xs,
                              ),
                              Text(
                                MyFormatter.formatDateTime(notification.sentAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(color: MyColors.secondaryTextColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
