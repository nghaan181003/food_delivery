import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/payment/payment_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentController extends GetxController {
  final logger = Logger();
  final paymentRepository = PaymentRepository.instance;
  final RxString paymentUrl = RxString('');
  final RxString transactionId = RxString('');
  final RxBool isLoading = RxBool(false);
  late WebViewController webViewController;
  VoidCallback? onPaymentSuccess;

  void setOnPaymentSuccess(VoidCallback callback) {
    onPaymentSuccess = callback;
  }

  @override
  void onInit() {
    super.onInit();

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('joodiesapp://vnpay_return')) {
            final uri = Uri.parse(request.url);
            final txnId = uri.queryParameters['txnId'];
            if (txnId != null) {
              checkPaymentResult(txnId);
            }
            paymentUrl.value = '';
            transactionId.value = '';
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onWebResourceError: (error) {
          // Loaders.errorSnackBar(
          //     title: 'Lỗi',
          //     message: 'Lỗi tải trang thanh toán: ${error.description}');
          // Get.back();
          if (onPaymentSuccess != null) {
            onPaymentSuccess!();
          }
        },
      ));
    // Enable hybrid composition for better iOS performance
    if (Platform.isIOS) {
      webViewController.setBackgroundColor(Colors.white);
    }
  }

  Future<void> createPayment(int amount, String orderId,
      {String? ipAddr}) async {
    isLoading.value = true;
    try {
      final response = await paymentRepository.createPaymentUrl(
        amount: amount,
        orderId: orderId,
        ipAddr: ipAddr,
      );
      if (response.status == Status.OK && response.data != null) {
        paymentUrl.value = response.data!['paymentUrl'] ?? '';
        transactionId.value = response.data!['transactionId'] ?? '';
        if (paymentUrl.value.isNotEmpty) {
          await webViewController.loadRequest(Uri.parse(paymentUrl.value));
        } else {
          throw Exception('Payment URL is empty');
        }
      } else {
        throw Exception(response.message ?? 'Failed to create payment URL');
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Lỗi', message: 'Lỗi tạo thanh toán: $e');
      print("Lỗi thanh toán vnpay ${e}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkPaymentResult(String txnId) async {
    isLoading.value = true;
    try {
      final response = await paymentRepository.checkTransactionStatus(txnId);
      if (response.status == Status.OK && response.data != null) {
        final status = response.data!['status'] ?? '';
        final message = response.data!['message'] ?? 'Không rõ trạng thái';
        Get.back();

        if (status == 'success') {
          Loaders.successSnackBar(
              title: 'Thanh toán thành công', message: message);
          if (onPaymentSuccess != null) {
            onPaymentSuccess!();
          }
        } else {
          Loaders.errorSnackBar(title: 'Thanh toán thất bại', message: message);
          Get.back();
        }
      } else {
        throw Exception(response.message ?? 'Invalid response format');
      }
    } catch (e, stackTrace) {
      logger.e('Error checking transaction: $e', stackTrace: stackTrace);
      Loaders.errorSnackBar(
          title: 'Lỗi', message: 'Lỗi kiểm tra giao dịch: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
