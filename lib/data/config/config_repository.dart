import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/admin/config/models/fee_config_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class ConfigRepository extends GetxController {
  static ConfigRepository get instance => Get.find();

  Future<ApiResponse<List<Config>>> getConfigs() async {
    try {
      final res = await HttpHelper.get("config");
      debugPrint("🟢 Phản hồi getConfigs: $res");
      final list = (res["data"] as List)
          .map((config) => Config.fromJson(config))
          .toList();
      return ApiResponse.completed(
          list, res["message"] ?? "Lấy danh sách cấu hình thành công");
    } catch (e) {
      debugPrint("🔴 Lỗi getConfigs: $e");
      debugPrint("🔴 Phản hồi thô: ${e.toString()}");
      String errorMessage = "Không thể lấy danh sách cấu hình: $e";
      if (e.toString().contains('SyntaxError: Unexpected token')) {
        errorMessage =
            'Lỗi server: Phản hồi không phải JSON. Vui lòng kiểm tra server hoặc URL API.';
      }
      return ApiResponse.error(errorMessage);
    }
  }

  Future<ApiResponse<Config>> getDeliveryFeeConfig() async {
    try {
      final res = await getConfigs();
      if (res.status == Status.OK) {
        final deliveryFeeConfig = res.data!
            .firstWhereOrNull((config) => config.type == 'DELIVERY_FEE');
        if (deliveryFeeConfig == null) {
          return ApiResponse.error("Không tìm thấy cấu hình phí vận chuyển");
        }
        return ApiResponse.completed(
            deliveryFeeConfig, "Lấy cấu hình phí vận chuyển thành công");
      } else {
        return ApiResponse.error(res.message!);
      }
    } catch (e) {
      debugPrint("🔴 Lỗi getDeliveryFeeConfig: $e");
      String errorMessage = "Không thể lấy cấu hình phí vận chuyển: $e";
      if (e.toString().contains('SyntaxError: Unexpected token')) {
        errorMessage =
            'Lỗi server: Phản hồi không phải JSON. Vui lòng kiểm tra server hoặc URL API.';
      }
      return ApiResponse.error(errorMessage);
    }
  }

  Future<ApiResponse<Config>> addConfig(Config newConfig) async {
    try {
      debugPrint("🟢 Thêm cấu hình mới: ${newConfig.toJson()}");
      final res = await HttpHelper.post("config", newConfig.toJson());
      debugPrint("🟢 Phản hồi addConfig: $res");
      return ApiResponse.completed(Config.fromJson(res["data"]),
          res["message"] ?? "Thêm cấu hình ${newConfig.type} thành công");
    } catch (e) {
      debugPrint("🔴 Lỗi addConfig: $e");
      String errorMessage = "Không thể thêm cấu hình ${newConfig.type}: $e";
      if (e.toString().contains('Đã tồn tại cấu hình phí vận chuyển')) {
        errorMessage =
            'Đã tồn tại cấu hình phí vận chuyển. Vui lòng cập nhật thay vì tạo mới.';
      }
      return ApiResponse.error(errorMessage);
    }
  }

  Future<ApiResponse<Config>> updateConfig(Config config) async {
    try {
      debugPrint("🟢 Cập nhật cấu hình: ${config.toJson()}");
      final res = await HttpHelper.put("config/${config.id}", config.toJson());
      debugPrint("🟢 Phản hồi updateConfig: $res");
      return ApiResponse.completed(Config.fromJson(res["data"]),
          res["message"] ?? "Cập nhật cấu hình ${config.type} thành công");
    } catch (e) {
      debugPrint("🔴 Lỗi updateConfig: $e");
      return ApiResponse.error(
          "Không thể cập nhật cấu hình ${config.type}: $e");
    }
  }

  Future<ApiResponse<String>> removeConfig(String configId) async {
    try {
      debugPrint("🟢 Xóa cấu hình ID: $configId");
      final res = await HttpHelper.delete("config/$configId");
      debugPrint("🟢 Phản hồi removeConfig: $res");
      return ApiResponse.completed(res["data"]?["_id"] ?? configId,
          res["message"] ?? "Xóa cấu hình thành công");
    } catch (e) {
      debugPrint("🔴 Lỗi removeConfig: $e");
      return ApiResponse.error("Không thể xóa cấu hình: $e");
    }
  }
}
