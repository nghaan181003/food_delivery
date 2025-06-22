import 'package:food_delivery_h2d/data/discount/get_discount_request.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_type.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/request/create_voucher_model.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/request/get_discount_request.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/request/get_voucher_order_request.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VoucherRepository extends GetxController {
  static VoucherRepository get instance => Get.find();

  static const String _voucherEndpoint = 'voucher';
  static const String _create = 'create';
  static const String _partner = 'partner';
  static const String _order = 'order';
  static const String _code = 'code';

  Future<ApiResponse<void>> createVoucher(CreateVoucherModel newVoucher) async {
    try {
      final res = await HttpHelper.post(
          '$_voucherEndpoint/$_create', newVoucher.toJson());
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(null, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<void>> updateStatus(
      {required String id, required VoucherStatus newStatus}) async {
    try {
      final data = {"voucherStatus": newStatus.toDbText};
      final res = await HttpHelper.patch('$_voucherEndpoint/$id/status', data);

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(null, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<VoucherModel>>> getVoucherInOrder(
      GetVoucherOrderRequest request) async {
    try {
      final res =
          await HttpHelper.post('$_voucherEndpoint/$_order', request.toJson());

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      final list = (res['data'] as List)
          .map((voucher) => VoucherModel.fromJson(voucher))
          .toList();

      return ApiResponse.completed(list, res["message"]);
    } catch (e) {
      print("Error get viucher: $e");

      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<VoucherModel>>> getVoucherByShop(
      GetVoucherRequest request) async {
    try {
      final res = await HttpHelper.get('$_voucherEndpoint/$_partner',
          queryParams: request.toJson());

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      final list = (res['data'] as List)
          .map((voucher) => VoucherModel.fromJson(voucher))
          .toList();

      return ApiResponse.completed(list, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<VoucherModel>>> getVoucherByCode(
      GetVoucherOrderRequest request) async {
    try {
      final res = await HttpHelper.get('$_voucherEndpoint/$_code',
          queryParams: request.toJson());

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      final list = (res['data'] as List)
          .map((voucher) => VoucherModel.fromJson(voucher))
          .toList();

      return ApiResponse.completed(list, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
