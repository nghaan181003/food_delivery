import 'package:food_delivery_h2d/data/discount/get_discount_request.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_type.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DiscountRepository extends GetxController {
  static DiscountRepository get instance => Get.find();

  static const String _discountEndpoint = 'discount';
  static const String _create = 'create';
  static const String _partner = 'partner';

  Future<ApiResponse<DiscountModel>> createDiscount(
      DiscountModel newDiscount) async {
    try {
      final res = await HttpHelper.post(
          '$_discountEndpoint/$_create', newDiscount.toJson());
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
          DiscountModel.fromJson(res["data"]), res["message"]);
    } catch (e) {
      print("Error creating discount: $e");
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<DiscountModel>> updateStatus(
      {required String id, required DiscountStatus newStatus}) async {
    try {
      final data = {"discountStatus": newStatus.toDbText};
      final res = await HttpHelper.patch('$_discountEndpoint/$id/status', data);

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
          DiscountModel.fromJson(res["data"]), res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<DiscountModel>>> getDiscounts(
      GetDiscountRequest request) async {
    try {
      final res = await HttpHelper.get('$_discountEndpoint/$_partner',
          queryParams: request.toJson());

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      final list = (res['data'] as List)
          .map((discount) => DiscountModel.fromJson(discount))
          .toList();

      return ApiResponse.completed(list, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
