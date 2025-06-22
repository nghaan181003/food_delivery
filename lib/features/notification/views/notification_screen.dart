import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/notification/controllers/notification_controller.dart';
import 'package:food_delivery_h2d/features/notification/views/widgets/notifications_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNotifications();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(title: Text("Thông báo")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value == Status.ERROR) {
          return Center(child: Text("Lỗi: ${controller.errorMessage}"));
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text("Không có thông báo nào."));
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(4),
          itemCount: controller.notifications.length + 1,
          itemBuilder: (context, index) {
            if (index < controller.notifications.length) {
              final notification = controller.notifications[index];
              print(LoginController.instance.currentUser.userId);
              return NotificationsTile(notification: notification);
            } else {
              return Obx(() => controller.isLoadingMore.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox());
            }
          },
        );
      }),
    );
  }
}
