// import 'dart:convert';
// import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
// import 'package:food_delivery_h2d/utils/helpers/hmac_helper.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class AppInfo {
//   static const int appId = 2553;
//   static const String macKey = 'PcY4iZIKFCIdgZvA6ueMcMHHUbRLYjPL';
//   static const String createOrderUrl =
//       'https://sb-openapi.zalopay.vn/v2/create';
// }

// class Helpers {
//   static String getAppTransId() {
//     final now = DateTime.now();
//     final date = DateFormat('yyMMdd').format(now);
//     final randomId = DateTime.now().millisecondsSinceEpoch % 1000000;
//     return '$date$randomId';
//   }

//   static String getMac(String key, String data) {
//     return HmacHelper.hmacHexEncode('HmacSHA256', key, data);
//   }
// }

// class ZalopayService {
//   Future<Map<String, dynamic>?> createOrder(String amount) async {
//     final appTime = DateTime.now().millisecondsSinceEpoch.toString();
//     final appTransId = Helpers.getAppTransId();
//     const embedData = '{}';
//     const items = '[]';
//     const appUser = 'Flutter_Demo';

//     final inputHMac = [
//       AppInfo.appId,
//       appTransId,
//       appUser,
//       amount,
//       appTime,
//       embedData,
//       items,
//     ].join('|');

//     final mac = Helpers.getMac(AppInfo.macKey, inputHMac);

//     final body = {
//       'app_id': AppInfo.appId.toString(),
//       'app_user': appUser,
//       'app_time': appTime,
//       'amount': amount,
//       'app_trans_id': appTransId,
//       'embed_data': embedData,
//       'item': items,
//       'bank_code': 'zalopayapp',
//       'description': 'Merchant pay for order #$appTransId',
//       'mac': mac,
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(AppInfo.createOrderUrl),
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         print("Failed: ${response.statusCode} - ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("Exception: $e");
//       return null;
//     }
//   }

//   Future<Map<String, dynamic>?> payWithZaloPay({
//     required String orderInfo,
//     required int amount,
//     required String orderId,
//   }) async {
//     try {
//       final orderResult = await createOrder(amount.toString());

//       if (orderResult?['return_code'] == 1) {
//         final zpTransToken = orderResult?['zp_trans_token'];

//         final payResult =
//             await FlutterZaloPaySdk.payOrder(zpToken: zpTransToken);

//         // Convert FlutterZaloPayStatus to Map<String, dynamic>
//         Map<String, dynamic> result;
//         switch (payResult) {
//           case FlutterZaloPayStatus.success:
//             result = {
//               'return_code': 1,
//               'return_message': 'Thanh toán thành công',
//               'zp_trans_id': zpTransToken,
//             };
//             break;
//           case FlutterZaloPayStatus.cancelled:
//             result = {
//               'return_code': 2,
//               'return_message': 'Người dùng hủy thanh toán',
//             };
//             break;
//           case FlutterZaloPayStatus.failed:
//           default:
//             result = {
//               'return_code': 3,
//               'return_message': 'Thanh toán thất bại',
//             };
//             break;
//         }
//         return result;
//       } else {
//         return orderResult;
//       }
//     } catch (e) {
//       print('Error in ZaloPay payment: $e');
//       return {'return_code': -1, 'return_message': 'Có lỗi xảy ra: $e'};
//     }
//   }
// }
