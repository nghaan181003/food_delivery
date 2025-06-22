import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class PaymentRepository extends GetxController {
  static PaymentRepository get instance => Get.find();
  final _paymentUrl = "payment";

  Future<ApiResponse<Map<String, String>>> createPaymentUrl({
    required int amount,
    required String orderId,
    String? ipAddr,
  }) async {
    try {
      final payload = {
        'amount': amount,
        'orderId': orderId,
        if (ipAddr != null) 'ipAddr': ipAddr,
      };
      final res =
          await HttpHelper.post('$_paymentUrl/create_payment_url', payload);

      if (res['hasError'] == true) {
        return ApiResponse.error(
            res['message'] ?? 'Failed to create payment URL');
      }

      final data = {
        'paymentUrl': res['data']['paymentUrl'] as String? ?? '',
        'transactionId': res['data']['transactionId'] as String? ?? '',
      };
      return ApiResponse.completed(
          data, res['message'] ?? 'Payment URL created successfully');
    } catch (e) {
      return ApiResponse.error('Failed to create payment URL: $e');
    }
  }

  Future<ApiResponse<Map<String, String>>> checkTransactionStatus(
      String txnId) async {
    try {
      final res = await HttpHelper.get('$_paymentUrl/check_transaction/$txnId');
      print("url: '$_paymentUrl/check_transaction/$txnId'");
      if (res['hasError'] == true) {
        return ApiResponse.error(
            res['message'] ?? 'Failed to check transaction status');
      }

      final data = {
        'status': res['data']['status'] as String? ?? '',
        'responseCode': res['data']['responseCode'] as String? ?? '',
        'message': res['data']['message'] as String? ?? 'Không rõ trạng thái',
      };
      return ApiResponse.completed(
          data, res['message'] ?? 'Transaction status checked successfully');
    } catch (e) {
      return ApiResponse.error('Failed to check transaction status: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> initiateZaloPayPayment({
    required int amount,
    required String orderId,
  }) async {
    try {
      print(
          "Initiating ZaloPay payment for order ID: $orderId with amount: $amount");
      final res = await HttpHelper.post(
        "$_paymentUrl/create-order",
        {
          'amount': amount,
          'order_id': orderId,
        },
      );
      print("Response from ZaloPay: $res");

      if (res["data"] == null || res["data"]["return_code"] == null) {
        return ApiResponse.error("Invalid response from server");
      }

      if (res["data"]["return_code"] != 1) {
        return ApiResponse.error(
          res["data"]["error"] ?? "Failed to create ZaloPay order",
        );
      }

      final paymentData = {
        "order_url": res["data"]["order_url"],
        "zp_trans_token": res["data"]["zp_trans_token"],
        "app_trans_id": res["data"]["app_trans_id"],
      };

      return ApiResponse.completed(
        paymentData,
        res["message"] ?? "ZaloPay order created successfully",
      );
    } catch (e) {
      Get.log('Error initiating ZaloPay payment: $e', isError: true);
      return ApiResponse.error(
        "An error occurred during payment initiation. Please try again.",
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> handleZaloPayCallBack(
      String orderId) async {
    try {
      final res = await HttpHelper.post(
        "$_paymentUrl/zalopay/callback",
        {
          'order_id': orderId,
        },
      );

      if (res["error"] != null) {
        return ApiResponse.error(res["error"]);
      }

      if (res["data"] == null || res["data"]["paymentStatus"] == null) {
        return ApiResponse.error("Invalid callback response from server");
      }

      final callbackData = {
        "orderId": res["data"]["orderId"],
        "paymentStatus": res["data"]["paymentStatus"],
        "totalAmount": res["data"]["totalAmount"],
      };

      return ApiResponse.completed(
        callbackData,
        res["message"] ?? "Payment status retrieved successfully",
      );
    } catch (e) {
      Get.log('Error handling ZaloPay callback: $e', isError: true);
      return ApiResponse.error(
        "An error occurred while checking payment status. Please try again.",
      );
    }
  }
}
