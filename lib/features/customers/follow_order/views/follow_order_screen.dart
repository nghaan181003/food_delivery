import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/views/address_selection/address_selection_screen.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/follow_order_controller.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/map_tracking_controller.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/order_status_controller.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/address_widget.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/driver_info_widget.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/floating_buttons_widget.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/invoice_widget.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/order_detail_widget.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/order_status_widget.dart';
import 'package:food_delivery_h2d/features/customers/order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/features/shippers/rating/controllers/driver_rating_controller.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class FollowOrderScreen extends StatefulWidget {
  final Order order;
  const FollowOrderScreen({super.key, required this.order});

  @override
  State<FollowOrderScreen> createState() => _FollowOrderScreenState();
}

class _FollowOrderScreenState extends State<FollowOrderScreen> {
  final orderSocketHandler = OrderSocketHandler();
  late Rx<Order> currentOrder;

  @override
  void initState() {
    super.initState();
    Get.put(OrderStatusController());
    Get.put(CustomerOrderController());
    Get.put(DriverRatingController());
    Get.put(MapTrackingController());
    Get.put(FollowOrderController());
    FollowOrderController.instance.order.value = widget.order;
    currentOrder = widget.order.obs;
    orderSocketHandler.joinRoom(widget.order.id);
  }

  @override
  void dispose() {
    orderSocketHandler.removeJoinRoom(widget.order.id);
    super.dispose();
  }

  void _updateAddress() async {
    final result = await Get.to(() => AddressSelectionScreen(
          isUpdate: true,
          orderId: widget.order.id,
        ));

    if (result != null && result is Map) {
      currentOrder.value = currentOrder.value.copyWith(
        custAddress: result['fullAddress'],
        custLat: result['latitude'],
        custLng: result['longitude'],
      );

      await FollowOrderController.instance.updateCustAddress(
        widget.order.id,
        result['fullAddress'],
        result['latitude'] as double,
        result['longitude'] as double,
      );

      if (FollowOrderController.instance.order.value != null) {
        currentOrder.value = FollowOrderController.instance.order.value!;
      }

      currentOrder.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderStatusController = Get.find<OrderStatusController>();
    final followOrderController = Get.find<FollowOrderController>();
    final ratingController = Get.find<DriverRatingController>();

    orderStatusController.orderStatus.value = widget.order.custStatus;
    orderSocketHandler.listenForOrderUpdates((newOrder) {
      orderStatusController.orderStatus.value = newOrder.custStatus;
      currentOrder.value = newOrder;
      MapTrackingController.instance.updateDriverLocation(
          currentOrder.value.shipperLat ?? 0.0,
          currentOrder.value.shipperLng ?? 0.0);
    });
    orderSocketHandler.listenForOrderCancelled((cancelledOrder) {
      orderStatusController.orderStatus.value = cancelledOrder.custStatus;
      currentOrder.value = cancelledOrder;
      MapTrackingController.instance.updateDriverLocation(
        currentOrder.value.shipperLat ?? 0.0,
        currentOrder.value.shipperLng ?? 0.0,
      );
    });

    return Scaffold(
      appBar: const CustomAppBar(title: Text("Theo dõi đơn hàng")),
      body: Obx(() => currentOrder.value.custStatus == "cancelled"
          ? Center(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Đơn đã bị hủy vì ${currentOrder.value.reason}"),
            ))
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, bottom: 68.0, right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: MyColors.primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          children: [
                            buildInfoCard(context: context, children: [
                              OrderStatusWidget(currentOrder: currentOrder)
                            ]),
                            buildInfoCard(context: context, children: [
                              DriverInfoWidget(
                                  currentOrder: currentOrder,
                                  ratingController: ratingController)
                            ]),
                            buildInfoCard(context: context, children: [
                              AddressWidget(
                                  currentOrder: currentOrder,
                                  onUpdateAddress: _updateAddress)
                            ]),
                            buildInfoCard(context: context, children: [
                              OrderDetailsWidget(currentOrder: currentOrder)
                            ]),
                            InvoiceWidget(order: currentOrder),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingButtonsWidget(
                    currentOrder: currentOrder,
                    followOrderController: followOrderController,
                    onPaymentSuccess: () {
                      followOrderController.orderRepository
                          .updatePaymentStatus(currentOrder.value.id);
                      currentOrder.value =
                          currentOrder.value.copyWith(paymentStatus: 'paid');
                    },
                  ),
                ),
              ],
            )),
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
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
