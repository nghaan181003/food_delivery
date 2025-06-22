import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/delivery_screen.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final OrderController ordersController = Get.find();
    final orderHandler = OrderSocketHandler();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: MyColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                MyFormatter.formatCurrency(
                    order.totalPrice! + order.deliveryFee!),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: MyColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Lấy hàng: ${order.restaurantName}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  order.restAddress.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(color: MyColors.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Giao hàng: ${order.customerName}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  order.custAddress.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: MyColors.errorColor, width: 1),
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ordersController.newOrders
                      .removeWhere((o) => o.id == order.id);
                  Loaders.successSnackBar(
                    title: "Thành công",
                    message: "Đơn hàng đã bị từ chối.",
                  );
                },
                child: const Text(
                  'Từ chối',
                  style: TextStyle(color: MyColors.errorColor, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.errorColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // ordersController.acceptOrder(order);
                  final invalidOrders = ordersController.orders.where((order) =>
                      order.driverStatus != 'delivered' &&
                      order.driverStatus != 'cancelled');

                  if (invalidOrders.isNotEmpty) {
                    Loaders.errorSnackBar(
                      title: "Nhận đơn thất bại",
                      message:
                          "Bạn không thể nhận đơn vì có đơn hàng chưa hoàn thành.",
                    );
                    return;
                  }
                  try {
                    ApiResponse<Order> orderResponse =
                        await OrderRepository.instance.getOrderById(order.id);
                    Order? newOrder = orderResponse.data!;
                    print("New Order: ${newOrder.toJson()}");
                    if (newOrder.assignedShipperId != null &&
                        newOrder.assignedShipperId != "") {
                      Loaders.errorSnackBar(
                        title: "Nhận đơn thất bại",
                        message:
                            "Đã có tài xế nhận đơn này. Vui lòng nhận đơn khác.",
                      );
                      ordersController.newOrders
                          .removeWhere((o) => o.id == order.id);
                      return;
                    }
                    if (newOrder.custStatus == 'cancelled') {
                      Loaders.errorSnackBar(
                        title: "Nhận đơn thất bại",
                        message:
                            "Đơn hàng đã được hủy. Vui lòng nhận đơn khác.",
                      );
                      ordersController.newOrders
                          .removeWhere((o) => o.id == order.id);
                      return;
                    }
                    Map<String, dynamic> newStatus = {
                      "custStatus": "heading_to_rest",
                      "driverStatus": "heading_to_rest",
                      "restStatus": "new"
                    };

                    await ordersController.updateOrderStatus(
                      LoginController.instance.currentUser.driverId,
                      orderId: order.id,
                      newStatus: newStatus,
                    );

                    orderHandler.updateStatusOrder(order.id, newStatus);

                    ordersController.newOrders
                        .removeWhere((o) => o.id == order.id);
                    Get.to(() => DeliveryScreen(order: order));
                  } catch (e) {
                    Get.snackbar("Error", "Failed to accept the order: $e",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text(
                  'Nhận đơn',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
