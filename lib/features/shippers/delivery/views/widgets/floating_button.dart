import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/delivery_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/tabs_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class DriverFloatingButtonsWidget extends StatelessWidget {
  final Rx<Order> currentOrder;
  final VoidCallback? onOrderPickedUp;

  const DriverFloatingButtonsWidget({
    super.key,
    required this.currentOrder,
    this.onOrderPickedUp,
  });

  @override
  Widget build(BuildContext context) {
    final deliveryController = Get.find<DeliveryController>();
    final ordersController = Get.find<OrderController>();
    final orderHandler = OrderSocketHandler();
    final tabsController = Get.find<TabsController>();
    final RxBool isExpanded = false.obs;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(() => isExpanded.value
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (currentOrder.value.driverStatus == 'heading_to_rest' &&
                      currentOrder.value.restStatus == 'completed')
                    FloatingActionButton.extended(
                      onPressed: () async {
                        try {
                          Map<String, dynamic> newStatus = {
                            "custStatus": "delivering",
                            "driverStatus": "delivering",
                            "restStatus": null
                          };

                          await ordersController.updateOrderStatus(
                            null,
                            orderId: currentOrder.value.id,
                            newStatus: newStatus,
                          );
                          Loaders.successSnackBar(
                              title: "Thành công!",
                              message: "Trạng thái đơn hàng đã được cập nhật.");

                          orderHandler.updateStatusOrder(
                              currentOrder.value.id, newStatus);
                        } catch (e) {
                          Get.snackbar(
                              "Error", "Failed to delivery the order: $e",
                              snackPosition: SnackPosition.BOTTOM);
                        }
                        tabsController.isRestButtonClicked.value = true;
                        DefaultTabController.of(context).animateTo(1);
                      },
                      label: const Text(
                        'Đã lấy đơn hàng',
                        style: TextStyle(
                            color: MyColors.white, fontWeight: FontWeight.bold),
                      ),
                      icon:
                          const Icon(Icons.check_circle, color: MyColors.white),
                      backgroundColor: MyColors.darkPrimaryColor,
                    ),
                  const SizedBox(height: 10),
                  // Nút hủy đơn hàng
                  if (currentOrder.value.restStatus != 'completed' &&
                      currentOrder.value.driverStatus != 'delivered')
                    FloatingActionButton.extended(
                      heroTag: 'cancel_fab',
                      onPressed: () => deliveryController.showCancelDialog(
                        context,
                        currentOrder.value.id,
                      ),
                      icon: const Icon(Icons.cancel, color: MyColors.white),
                      label: const Text(
                        'Hủy đơn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.white,
                        ),
                      ),
                      backgroundColor: MyColors.darkPrimaryColor,
                    ),
                  const SizedBox(height: 10),
                ],
              )
            : const SizedBox()),
        // FloatingActionButton(
        //   onPressed: () => isExpanded.value = !isExpanded.value,
        //   backgroundColor: MyColors.darkPrimaryColor,
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        //   child: Obx(() => Icon(
        //         isExpanded.value ? Icons.close : Icons.menu,
        //         color: MyColors.white,
        //       )),
        // ),
      ],
    );
  }
}
