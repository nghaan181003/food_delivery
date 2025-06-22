import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/pagination_response.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class ToppingRepository extends GetxController {
  static ToppingRepository get instance => Get.find();

  static const String _toppingGroupEndpoint = "toppingGroup";
  static const String _toppingEndpoint = "topping";

  //TODO: Danh sach chi tiet cac topping group
  Future<PaginationResponse<List<ToppingGroupModel>>> getAllByShop(
      {required String partnerId, int page = 1, int limit = 10}) async {
    try {
      final res =
          await HttpHelper.get("$_toppingGroupEndpoint/all", queryParams: {
        'tpShopId': partnerId,
        'page': page,
        'limit': limit,
      });
      if (res["status"] == "error") {
        return PaginationResponse.error(res["message"]);
      }
      final list = (res['data'] as List)
          .map((tp) => ToppingGroupModel.fromJson(tp))
          .toList();
      return PaginationResponse.completed(
        list,
        res["message"],
        totalPages: res["totalPages"],
        totalItems: res["totalItems"],
        currentPage: res["currentPage"],
        pageSize: res["pageSize"],
      );
    } catch (e) {
      return PaginationResponse.error(e.toString());
    }
  }

  //TODO: create new topping
  Future<ApiResponse<ToppingModel>> saveTopping(ToppingModel newTopping) async {
    try {
      final res = await HttpHelper.post(
          "$_toppingEndpoint/create", newTopping.toJson());
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      return ApiResponse.completed(
          ToppingModel.fromJson(res["data"]), res["message"]);
    } catch (e) {
     
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<ToppingGroupModel>> saveToppingGroup(ToppingGroupModel newToppingGroup) async {
    try {
      final res = await HttpHelper.post(
          "$_toppingGroupEndpoint/create", newToppingGroup.toJson());
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      return ApiResponse.completed(
          ToppingGroupModel.fromJson(res["data"]), res["message"]);
    } catch (e) {
      print("[1]:: $e");
      return ApiResponse.error(e.toString());
    }
  }

  //TODO: delete topping
  Future<ApiResponse<ToppingModel>> deleteTopping(String toppingId) async {
    try {
      final res =
          await HttpHelper.delete("$_toppingEndpoint/delete/$toppingId");
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
          ToppingModel.fromJson(res["data"]), res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<ToppingGroupModel>> deleteToppingGroup(String toppingGroupId) async {
    try {
      final res =
          await HttpHelper.delete("$_toppingGroupEndpoint/delete/$toppingGroupId");
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
          ToppingGroupModel.fromJson(res["data"]), res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

 

}
