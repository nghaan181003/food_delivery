import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/shippers/profile/controllers/update_driver_request_controller.dart';
import 'package:food_delivery_h2d/features/shippers/profile/views/widgets/history_driver_update_tile.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class HistoryDriverUpdateRequest extends StatelessWidget {
  const HistoryDriverUpdateRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateDriverRequestController());
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Lịch sử chỉnh sửa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.sm),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.updateList.isEmpty) {
            return const Center(
              child: Text("Không có yêu cầu chỉnh sửa nào"),
            );
          }
          return ListView.builder(
              itemCount: controller.updateList.length,
              itemBuilder: (context, index) {
                final request = controller.updateList[index];
                return HistoryDriverUpdateTile(request: request);
              });
        }),
      ),
    );
  }
}
