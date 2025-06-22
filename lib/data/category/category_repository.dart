import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  Future<List<Category>> getCategoriesInRestaurant(String partnerId) async {
    try {
      final res = await HttpHelper.get("category/${partnerId.toString()}");
      final list = (res["data"] as List)
          .map((category) => Category.fromJson(category))
          .toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> removeCategory(String categoryId) async {
    try {
      await HttpHelper.delete("category/${categoryId.toString()}");
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<Category>> removeCategoryV2(String categoryId) async {
    try {
      final res = await HttpHelper.delete("category/${categoryId.toString()}");
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
          Category.fromJson(res["data"]), res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<String>> reorderCategoryIndex(
      String partnerId, List<String> indexes) async {
    final data = {"partnerId": partnerId, "categoryOrderIdx": indexes};

    try {
      final res = await HttpHelper.post("category/reorder", data);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(res["message"], res["message"]);
    } catch (e) {
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<Category> addCategory(Category newCategory) async {
    final reqBody = newCategory.toJson();
    try {
      final res = await HttpHelper.post("category", reqBody);

      return Category.fromJson(res["data"]);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<Category>> addCategoryV2(Category newCategory) async {
    final reqBody = newCategory.toJson();
    try {
      final res = await HttpHelper.post("category", reqBody);
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
          Category.fromJson(res["data"]), res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<Category> updateCategory(Category oldCategory) async {
    try {
      final res = await HttpHelper.put(
          "category/${oldCategory.categoryId}", oldCategory);
      return Category.fromJson(res["data"]);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
