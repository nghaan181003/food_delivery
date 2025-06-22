import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/chat/views/chat_driver.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/tabs_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/delivery_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/handle_status_text.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CustomerTab extends StatelessWidget {
  final Order order;

  const CustomerTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final TabsController controller = Get.put(TabsController());
    final OrderController ordersController = Get.find();
    final DeliveryController deliveryController =
        Get.find<DeliveryController>();
    final orderHandler = OrderSocketHandler();

    var currentOrder = order.obs;

    orderHandler.joinRoom(order.id);

    orderHandler.listenForOrderUpdates((newOrder) {
      currentOrder.value = newOrder;
    });

    return Scaffold(
      body: Obx(() {
        return currentOrder.value.custStatus == "cancelled"
            ? Center(
                child:
                    Text("Đơn hàng đã bị hủy vì ${currentOrder.value.reason}"))
            : SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, bottom: 68.0, right: 8.0),
                child: Column(
                  children: [
                    // Customer Information
                    buildInfoCard(
                      context: context,
                      children: [
                        Text(
                          order.customerName,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.custPhone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.custAddress ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // Chat Button
                    buildInfoCard(
                      context: context,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                ChatDriver(
                                  customerId: order.customerId,
                                  driverId: LoginController
                                      .instance.currentUser.userId,
                                  currentUserId: LoginController
                                      .instance.currentUser.userId,
                                  customerName: currentOrder.value.customerName
                                      .toString(),
                                  driverImage: currentOrder
                                      .value.driverProfileUrl
                                      .toString(),
                                  orderId: order.id,
                                ),
                              );
                            },
                            child: const Text(
                              "Gửi tin nhắn",
                              style: TextStyle(
                                fontSize: 14,
                                color: MyColors.primaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Driver Status
                    buildInfoCard(
                      context: context,
                      children: [
                        Center(
                          child: Text(
                            "Trạng thái - ${getDriverStatusText(currentOrder.value.driverStatus)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: MyColors.primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Order Details
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
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              child: Text(
                                '#${order.id}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const TextStyle(fontSize: 14),
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
                              width: 50,
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
                        ...order.orderItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    item.itemName,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
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
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              MyFormatter.formatCurrency(order.totalPrice ?? 0),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Phí vận chuyển: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              MyFormatter.formatCurrency(
                                  order.deliveryFee ?? 0),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng tiền: ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primaryTextColor),
                            ),
                            Text(
                              MyFormatter.formatCurrency(
                                  (order.totalPrice ?? 0) +
                                      (order.deliveryFee ?? 0)),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tiền thu khách hàng: ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primaryTextColor),
                            ),
                            if (order.paymentStatus == "paid" ||
                                order.paymentMethod != "Cash")
                              const Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                              )
                            else
                              Text(
                                MyFormatter.formatCurrency(
                                    (order.totalPrice ?? 0) +
                                        (order.deliveryFee ?? 0)),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ],
                    ),

                    // Restaurant Invoice
                    buildInfoCard(
                      context: context,
                      children: [
                        const Text(
                          'Hóa đơn quán',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng hóa đơn',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              MyFormatter.formatCurrency(order.totalPrice ?? 0),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quán giảm giá',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              '0 VND',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(
                            color: MyColors.dividerColor, thickness: 1),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng tiền thanh toán',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              MyFormatter.formatCurrency(order.totalPrice ?? 0),
                              style: const TextStyle(
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (currentOrder.value.driverStatus != "cancelled")
                      ElevatedButton.icon(
                        onPressed: () => deliveryController.showReportDialog(
                          context,
                          currentOrder.value.id,
                        ),
                        icon: const Icon(Icons.cancel, color: MyColors.white),
                        label: const Text(
                          'Báo cáo đơn hàng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.darkPrimaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
      }),
      floatingActionButton: Obx(() {
        if (!controller.isCustButtonClicked.value &&
            currentOrder.value.driverStatus == "delivering") {
          return FloatingActionButton.extended(
            heroTag: 'customer_delivered_fab',
            onPressed: () async {
              try {
                Map<String, dynamic> newStatus = {
                  "custStatus": "delivered",
                  "driverStatus": "delivered",
                  "restStatus": "completed"
                };

                await ordersController.updateOrderStatus(
                  null,
                  orderId: order.id,
                  newStatus: newStatus,
                );

                controller.isCustButtonClicked.value = true;
                Get.back();
                Loaders.successSnackBar(
                    title: "Hoàn thành", message: "Đã hoàn thành đơn hàng.");

                orderHandler.updateStatusOrder(order.id, newStatus);
              } catch (e) {
                Loaders.errorSnackBar(
                    title: "Đã xảy ra lỗi", message: e.toString());
              }
            },
            label: const Text(
              'Đã giao đơn hàng',
              style: TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(
              Icons.check_circle,
              color: MyColors.white,
            ),
            backgroundColor: MyColors.darkPrimaryColor,
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget buildInfoCard(
      {required BuildContext context, required List<Widget> children}) {
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
