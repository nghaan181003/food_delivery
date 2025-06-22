import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/delivery_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/tabs_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/widgets/floating_button.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/handle_status_text.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class RestaurantTab extends StatelessWidget {
  final Order order;

  const RestaurantTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final TabsController controller = Get.put(TabsController());
    final OrderController ordersController = Get.find();
    final deliveryController = Get.find<DeliveryController>();

    final orderHandler = OrderSocketHandler();

    var currentOrder = order.obs;

    orderHandler.joinRoom(order.id);

    orderHandler.listenForOrderUpdates((newOrder) {
      currentOrder.value = newOrder;
    });

    return Scaffold(
      body: Obx(
        () => currentOrder.value.custStatus == "cancelled"
            ? Center(
                child:
                    Text("Đơn hàng đã bị hủy vì ${currentOrder.value.reason}"))
            : SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, bottom: 68.0, right: 8.0),
                child: Column(
                  children: [
                    // Restaurant Information
                    buildInfoCard(
                      context: context,
                      children: [
                        Text(
                          order.restaurantName,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.restAddress ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Trả: ',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              MyFormatter.formatCurrency(order.totalPrice ?? 0),
                              style: const TextStyle(
                                  fontSize: 14, color: MyColors.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Driver Status
                    buildInfoCard(
                      context: context,
                      children: [
                        Center(
                          child: Text(
                            "Trạng thái - ${getDriverStatusText(order.driverStatus)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: MyColors.primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Customer Notes
                    buildInfoCard(
                      context: context,
                      children: [
                        const Text(
                          'Khách hàng ghi chú',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: MyColors.primaryColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.note,
                          style: const TextStyle(
                              fontSize: 14, color: MyColors.primaryTextColor),
                        ),
                      ],
                    ),

                    // Order Details with Items
                    buildInfoCard(
                      context: context,
                      children: [
                        const Text(
                          'Chi tiết đơn hàng',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mã đơn hàng:',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                '#${order.id}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Số lượng món: ${order.orderItems.length}',
                          style: const TextStyle(
                              fontSize: 14, color: MyColors.primaryTextColor),
                        ),
                        const Divider(
                            color: MyColors.dividerColor, thickness: 1),
                        const SizedBox(height: 8),
                        // Table Headers
                        const Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                'Tên món',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 50, // Fixed width for the second column
                              child: Text(
                                'SL',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Thành tiền',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Order Items List
                        ...order.orderItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150, // Matches the header column width
                                  child: Text(
                                    item.itemName,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 50, // Matches the header column width
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    MyFormatter.formatCurrency(item.totalPrice),
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(
                            color: MyColors.dividerColor, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng: ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              MyFormatter.formatCurrency(order.totalPrice ?? 0),
                              style: const TextStyle(
                                fontSize: 14,
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: Obx(() {
        if (currentOrder.value.restStatus == 'new') {
          return FloatingActionButton.extended(
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
          );
        }
        if (currentOrder.value.driverStatus == 'heading_to_rest' &&
            currentOrder.value.restStatus == 'completed') {
          return FloatingActionButton.extended(
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
                Get.snackbar("Error", "Failed to delivery the order: $e",
                    snackPosition: SnackPosition.BOTTOM);
              }
              DefaultTabController.of(context).animateTo(1);
            },
            label: const Text(
              'Đã lấy đơn hàng',
              style:
                  TextStyle(color: MyColors.white, fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.check_circle, color: MyColors.white),
            backgroundColor: MyColors.darkPrimaryColor,
          );
        }

        return const SizedBox();
      }),
    );
  }

  Widget buildInfoCard({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
