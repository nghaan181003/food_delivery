import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/distance_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class DistanceRepository extends GetxController {
  static DistanceRepository get instance => Get.find();

  Future<ApiResponse<Distance>> getDistance(
      Map<String, double?> point1, Map<String, double?> point2) async {
    try {
      final response = await HttpHelper.post(
        'map/distance',
        {
          'point1': point1,
          'point2': point2,
        },
      );
      debugPrint("🟢 Phản hồi getDistance (raw): ${response.toString()}");
      if (response['status'] == 200) {
        return ApiResponse.completed(
          Distance.fromJson(response['data']),
          response['message'] ?? 'Tính khoảng cách thành công',
        );
      } else {
        debugPrint(
            "🔴 Lỗi API: ${response['status']} - ${response['message']}");
        return ApiResponse.error(
            'Lỗi API: ${response['message'] ?? 'Không xác định'}');
      }
    } catch (e) {
      debugPrint("🔴 Lỗi getDistance: Exception: $e");
      return ApiResponse.error('Không thể tính khoảng cách: $e');
    }
  }
}
