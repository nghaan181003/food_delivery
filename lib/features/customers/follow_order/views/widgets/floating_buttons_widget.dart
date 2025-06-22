import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/follow_order_controller.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/payment_controller.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/map_tracking.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/vnpay_payment_screen.dart';
import 'package:food_delivery_h2d/features/customers/order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class FloatingButtonsWidget extends StatelessWidget {
  final Rx<Order> currentOrder;
  final FollowOrderController followOrderController;
  final VoidCallback? onPaymentSuccess;

  const FloatingButtonsWidget({
    super.key,
    required this.currentOrder,
    required this.followOrderController,
    this.onPaymentSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final customerOrderController = Get.find<CustomerOrderController>();
    final paymentController = Get.put(PaymentController());

    // Set onPaymentSuccess in PaymentController
    paymentController.setOnPaymentSuccess(() {
      if (onPaymentSuccess != null) {
        onPaymentSuccess!();
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(() => followOrderController.isExpanded.value
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (currentOrder.value.assignedShipperId != null &&
                      currentOrder.value.assignedShipperId != '')
                    FloatingActionButton.extended(
                      heroTag: 'track_order_fab',
                      onPressed: () =>
                          Get.to(() => MapTracking(order: currentOrder.value)),
                      icon: const Icon(Icons.map, color: MyColors.white),
                      label: const Text('Theo dõi đơn',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.white)),
                      backgroundColor: Colors.teal,
                    ),
                  const SizedBox(height: 10),
                  if (currentOrder.value.paymentStatus == 'pending' &&
                      currentOrder.value.paymentMethod != 'Cash')
                    FloatingActionButton.extended(
                      heroTag: 'vnpay_fab',
                      onPressed: () async {
                        await paymentController.createPayment(
                          (currentOrder.value.totalPrice ?? 0) +
                              (currentOrder.value.deliveryFee ?? 0),
                          currentOrder.value.id,
                        );
                        Get.to(() => const VnpayPaymentScreen(), arguments: {
                          'onPaymentSuccess': onPaymentSuccess,
                        });
                      },
                      icon: const Icon(Icons.payment, color: MyColors.white),
                      label: const Text(
                        'Thanh toán bằng VNPAY',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  const SizedBox(height: 10),
                  // if (currentOrder.value.paymentStatus == 'pending')
                  //   FloatingActionButton.extended(
                  //     heroTag: 'toggle_fab',
                  //     onPressed: () async {
                  //       await CustomerOrderController.instance.processPayment(
                  //         (currentOrder.value.totalPrice ?? 0) +
                  //             (currentOrder.value.deliveryFee ?? 0),
                  //         currentOrder.value.id,
                  //       );
                  //       if (onPaymentSuccess != null) {
                  //         onPaymentSuccess!();
                  //       }
                  //     },
                  //     icon: const Icon(Icons.payment, color: MyColors.white),
                  //     label: const Text('Thanh toán bằng ZaloPay',
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.bold,
                  //             color: MyColors.white)),
                  //     backgroundColor: Colors.green,
                  //   ),
                  // const SizedBox(height: 10),
                  if (currentOrder.value.custStatus == 'waiting')
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () => customerOrderController.showCancelDialog(
                          context, currentOrder.value.id),
                      icon: const Icon(Icons.cancel, color: MyColors.white),
                      label: const Text('Hủy đơn',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.white)),
                      backgroundColor: Colors.red,
                    ),
                  const SizedBox(height: 10),
                ],
              )
            : const SizedBox()),
        FloatingActionButton(
          onPressed: () => followOrderController.isExpanded.value =
              !followOrderController.isExpanded.value,
          backgroundColor: MyColors.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Obx(() => Icon(
              followOrderController.isExpanded.value ? Icons.close : Icons.menu,
              color: MyColors.white)),
        ),
      ],
    );
  }
}
