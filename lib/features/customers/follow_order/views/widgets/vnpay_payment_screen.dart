// vnpay_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/payment_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VnpayPaymentScreen extends StatelessWidget {
  const VnpayPaymentScreen({super.key, this.onPaymentSuccess});
  final VoidCallback? onPaymentSuccess;

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.find<PaymentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán VNPay'),
        backgroundColor: MyColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            paymentController.paymentUrl.value = '';
            paymentController.transactionId.value = '';
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (paymentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (paymentController.paymentUrl.value.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: () => paymentController.createPayment(
                  100000, DateTime.now().millisecondsSinceEpoch.toString()),
              child: const Text('Thanh toán VNPay'),
            ),
          );
        }
        return WebViewWidget(controller: paymentController.webViewController);
      }),
    );
  }
}
