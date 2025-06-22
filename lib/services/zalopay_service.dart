// import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:food_delivery_h2d/data/payment/payment_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ZalopayService extends GetxController {
  static ZalopayService get instance => Get.find();
  final paymentRepository = Get.put(PaymentRepository());

  /// Initiates a ZaloPay payment and handles the payment result.
  Future<Map<String, dynamic>?> payWithZaloPay({
    required String orderInfo,
    required int amount,
    required String orderId,
  }) async {
    // try {
    //   Get.log(
    //     'Starting ZaloPay payment for order $orderId with amount $amount',
    //     isError: false,
    //   );
    //   final response = await paymentRepository.initiateZaloPayPayment(
    //     amount: amount,
    //     orderId: orderId,
    //   );

    //   if (response.status == Status.ERROR) {
    //     Get.log('Payment initiation failed: ${response.message}',
    //         isError: true);
    //     return null;
    //   }

    //   final orderResult = response.data;
    //   if (orderResult == null) {
    //     Get.log('Response data is null', isError: true);
    //     Loaders.errorSnackBar(
    //       title: 'Lỗi Thanh Toán',
    //       message: 'Dữ liệu trả về từ server không hợp lệ',
    //     );
    //     return null;
    //   }

    //   // Lấy zp_trans_token và app_trans_id
    //   final zpTransToken = orderResult['zp_trans_token'] as String?;
    //   final appTransId = orderResult['app_trans_id'] as String?;

    //   if (zpTransToken == null || appTransId == null) {
    //     Get.log('Missing zp_trans_token or app_trans_id', isError: true);
    //     Loaders.errorSnackBar(
    //       title: 'Lỗi Thanh Toán',
    //       message: 'Thiếu thông tin giao dịch ZaloPay',
    //     );
    //     return null;
    //   }

    //   // Thanh toán bằng ZaloPay SDK
    //   Get.log('Calling ZaloPay SDK with zp_trans_token: $zpTransToken',
    //       isError: false);
    //   // final payResult = await FlutterZaloPaySdk.payOrder(zpToken: zpTransToken);
    //   // Get.log('ZaloPay SDK result: $payResult', isError: false);
    //   const payResult =
    //       FlutterZaloPayStatus.success; // Giả lập kết quả thành công
    //   // Xử lý kết quả thanh toán
    //   Map<String, dynamic> result;
    //   switch (payResult) {
    //     case FlutterZaloPayStatus.success:
    //       Get.log('Payment successful, verifying with server', isError: false);
    //       final statusResponse = await _verifyPaymentStatusWithRetry(orderId);
    //       if (statusResponse.status == Status.OK &&
    //           statusResponse.data?['paymentStatus'] == 'paid') {
    //         result = {
    //           'return_code': 1,
    //           'return_message': 'Thanh toán thành công',
    //           'zp_trans_token': zpTransToken,
    //           'app_trans_id': appTransId,
    //         };
    //       } else {
    //         Get.log('Server verification failed: ${statusResponse.message}',
    //             isError: true);
    //         result = {
    //           'return_code': 3,
    //           'return_message': 'Thanh toán chưa được xác nhận bởi server',
    //           'app_trans_id': appTransId,
    //         };
    //         Loaders.waringSnackBar(
    //           title: 'Chờ Xác Nhận',
    //           message: 'Thanh toán đang được xử lý. Vui lòng kiểm tra lại sau.',
    //         );
    //         // Polling để kiểm tra trạng thái
    //         final pollResult = await pollPaymentStatus(orderId);
    //         if (pollResult != null && pollResult['return_code'] == 1) {
    //           result = pollResult;
    //         }
    //       }
    //       break;
    //     case FlutterZaloPayStatus.cancelled:
    //       Get.log('Payment cancelled by user', isError: false);
    //       result = {
    //         'return_code': 2,
    //         'return_message': 'Người dùng hủy thanh toán',
    //         'app_trans_id': appTransId,
    //       };
    //       Loaders.waringSnackBar(
    //         title: 'Hủy Thanh Toán',
    //         message: 'Bạn đã hủy thanh toán',
    //       );
    //       break;
    //     case FlutterZaloPayStatus.failed:
    //     default:
    //       Get.log('Payment failed', isError: true);
    //       result = {
    //         'return_code': 3,
    //         'return_message': 'Thanh toán thất bại',
    //         'app_trans_id': appTransId,
    //       };
    //       // Thử kiểm tra trạng thái server
    //       final statusResponse = await _verifyPaymentStatusWithRetry(orderId);
    //       if (statusResponse.status == Status.OK &&
    //           statusResponse.data?['paymentStatus'] == 'paid') {
    //         Get.log('Server confirmed payment despite SDK failure',
    //             isError: false);
    //         result = {
    //           'return_code': 1,
    //           'return_message': 'Thanh toán thành công (xác nhận từ server)',
    //           'zp_trans_token': zpTransToken,
    //           'app_trans_id': appTransId,
    //         };
    //       }
    //       break;
    //   }

    //   return result;
    // } catch (e) {
    //   Get.log('Error in ZaloPay payment: $e', isError: true);
    //   return null;
    // }
  }

  /// Verifies payment status with retry logic
  Future<ApiResponse<Map<String, dynamic>>> _verifyPaymentStatusWithRetry(
      String orderId,
      {int maxRetries = 3,
      int delaySeconds = 2}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final response = await paymentRepository.handleZaloPayCallBack(orderId);
        Get.log('Verification attempt ${i + 1}: $response', isError: false);
        if (response.status == Status.OK &&
            response.data?['paymentStatus'] != null) {
          return response;
        }
        Get.log('Retry ${i + 1} failed: ${response.message}', isError: true);
      } catch (e) {
        Get.log('Verification error on attempt ${i + 1}: $e', isError: true);
      }
      await Future.delayed(Duration(seconds: delaySeconds));
    }
    return ApiResponse.error(
        'Không thể xác nhận trạng thái thanh toán sau $maxRetries lần thử');
  }

  /// Polls the server to check payment status
  Future<Map<String, dynamic>?> pollPaymentStatus(String orderId,
      {int maxAttempts = 5, int delaySeconds = 5}) async {
    for (int i = 0; i < maxAttempts; i++) {
      try {
        final response = await paymentRepository.handleZaloPayCallBack(orderId);
        Get.log('Poll attempt ${i + 1}: $response', isError: false);
        if (response.status == Status.OK &&
            response.data?['paymentStatus'] == 'paid') {
          return {
            'return_code': 1,
            'return_message': 'Thanh toán thành công',
            'app_trans_id': response.data?['app_trans_id'] ?? orderId,
          };
        }
      } catch (e) {
        Get.log('Poll error: $e', isError: true);
      }
      await Future.delayed(Duration(seconds: delaySeconds));
    }
    Get.log('Payment status not confirmed after $maxAttempts attempts',
        isError: true);
    return null;
  }
}
