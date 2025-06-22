import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/order_status_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class OrderStatusWidget extends StatelessWidget {
  final Rx<Order> currentOrder; // Added to access paymentStatus

  const OrderStatusWidget({super.key, required this.currentOrder});

  @override
  Widget build(BuildContext context) {
    final orderStatusController = Get.find<OrderStatusController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            'Trạng thái đơn - ${StatusHelper.custStatusTranslations[orderStatusController.orderStatus.value]}...',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.inventory_outlined,
                size: 18, color: MyColors.primaryColor),
            const SizedBox(width: 8),
            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear,
                  width: 55,
                  height: 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: orderStatusController.getContainerColor(1),
                  ),
                  child: LinearProgressIndicator(
                    value: orderStatusController.container1Progress.value,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        MyColors.primaryColor),
                  ),
                )),
            const SizedBox(width: 8),
            const Icon(Icons.local_dining,
                size: 18, color: MyColors.primaryColor),
            const SizedBox(width: 8),
            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear,
                  width: 55,
                  height: 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: orderStatusController.getContainerColor(2),
                  ),
                  child: LinearProgressIndicator(
                    value: orderStatusController.container2Progress.value,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        MyColors.primaryColor),
                  ),
                )),
            const SizedBox(width: 8),
            const Icon(Icons.delivery_dining,
                size: 18, color: MyColors.primaryColor),
            const SizedBox(width: 8),
            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear,
                  width: 55,
                  height: 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: orderStatusController.getContainerColor(3),
                  ),
                  child: LinearProgressIndicator(
                    value: orderStatusController.container3Progress.value,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        MyColors.primaryColor),
                  ),
                )),
            const SizedBox(width: 8),
            const Icon(Icons.home, size: 18, color: MyColors.primaryColor),
          ],
        ),
      ],
    );
  }
}
