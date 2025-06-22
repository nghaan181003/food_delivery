import 'package:food_delivery_h2d/data/request/item/link_topping_request.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/pagination_response.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_item_model.dart';
import 'package:food_delivery_h2d/features/customers/search/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/top_selling.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class ItemRepository extends GetxController {
  static ItemRepository get instance => Get.find();

  Future<List<Item>> getItemsByCategoryID(String categoryId) async {
    try {
      final res =
          await HttpHelper.get("item/category/${categoryId.toString()}");
      final list = (res["data"] as List)
          .map((category) => Item.fromJson(category))
          .toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<Item>> getItemsByCategoryIDInCustomer(String categoryId) async {
    try {
      final res = await HttpHelper.get(
          "item/customer/category/${categoryId.toString()}");
      final list = (res["data"] as List)
          .map((category) => Item.fromJson(category))
          .toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<Item>> updateItem(
      Item oldItem, List<http.MultipartFile>? files) async {
    try {
      final res = await HttpHelper.putWithFiles(
          "item/${oldItem.itemId.toString()}", oldItem.toJson(), files ?? []);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      await HttpHelper.put("item/delete/${itemId.toString()}");
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<Item>> addItem(
      Item newItem, List<http.MultipartFile> files) async {
    try {
      final res =
          await HttpHelper.postWithFiles("item", newItem.toJson(), files);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<List<ItemModel>> searchItems(String query) async {
    try {
      final response =
          await HttpHelper.get("item/customer/search?query=$query");

      List<dynamic> data = response['data'] as List<dynamic>;

      return data.map((item) => ItemModel.fromJson(item)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Item>> searchItemInHome(String query) async {
    try {
      final response =
          await HttpHelper.get("item/customer/home?keySearch=$query");

      List<dynamic> data = response['data'] as List<dynamic>;

      return data.map((item) => Item.fromJson(item)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<ApiResponse<Item>> decreaseQuantity(
      String orderId, int quantity) async {
    try {
      final res = await HttpHelper.patch(
          "item/${orderId.toString()}/quantity", {"quantity": quantity});

      print("GIAM SO LUONG ${res.toString()}");

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Item>> increaseSales(String orderId, int quantity) async {
    try {
      final res = await HttpHelper.patch(
          "item/${orderId.toString()}/sales", {"quantity": quantity});

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<List<RatingModel>> fecthRatingItem(String itemId) async {
    try {
      final response = await HttpHelper.get("item/rating/$itemId");

      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => RatingModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<List<TopItemModel>> fetchTopItems() async {
    try {
      final response = await HttpHelper.get("item/customer/topItem");

      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => TopItemModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<List<TopItemModel>> fetchFavoriteList(String userId) async {
    try {
      final response = await HttpHelper.get("item/favorite/$userId");

      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => TopItemModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<void> deleteFavoriteItem(String userId, String itemId) async {
    try {
      await HttpHelper.delete("item/favorite/$userId/$itemId");
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> addFavoriteItem(String userId, String itemId) async {
    try {
      await HttpHelper.post("item/add/favorite", {
        "userId": userId,
        "itemId": itemId,
      });
    } catch (e) {
      print("Error adding favorite item: $e");
    }
  }

  Future<PaginationResponse<List<ToppingGroupModel>>> getLinkedToppingGroups(
      {required String id, int page = 1, int limit = 10}) async {
    try {
      final res = await HttpHelper.get("item/topping/linked", queryParams: {
        'id': id,
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

  Future<PaginationResponse<List<ToppingGroupModel>>> getUnlinkedToppingGroups(
      {required String id, int page = 1, int limit = 10}) async {
    try {
      final res = await HttpHelper.get("item/topping/unlinked", queryParams: {
        'id': id,
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

  Future<ApiResponse<bool>> linkToppingGroup(
      {required LinkToppingRequest linkToppingRequest}) async {
    try {
      final res = await HttpHelper.put(
          "item/topping/link/${linkToppingRequest.itemId}",
          linkToppingRequest.toJson());
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(true, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // * Get topping list by product id for customer
  Future<PaginationResponse<List<ToppingGroupModel>>>
      getToppingsByProductIdForCustomer(
          {required String id, int page = 1, int limit = 20}) async {
    try {
      final res = await HttpHelper.get("item/customer/toppings", queryParams: {
        'id': id,
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

  Future<ApiResponse<List<Item>>> getItemsByPartnerId(
      {required String partnerId}) async {
    try {
      final res = await HttpHelper.get("item/partner/$partnerId");
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      final list =
          (res['data'] as List).map((item) => Item.fromJson(item)).toList();
      return ApiResponse.completed(list, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<List<TopSellingItem>> getTopSelling(String partnerId) async {
    try {
      final response =
          await HttpHelper.get("item/statistic/top_selling/$partnerId");
      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => TopSellingItem.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<Item> getItemById(String id) async {
    try {
      final res = await HttpHelper.get(
          "item/$id");
      return Item.fromJson(res["data"]);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> updateScheduleItem(
      String id, List<DaySchedule> schedule) async {
    try {
      final data = {
        'schedule': schedule.map((daySchedule) {
          return {
            'day': daySchedule.day,
            'timeSlots': daySchedule.timeSlots.map((slot) {
              return {
                'open': slot.open,
                'close': slot.close,
              };
            }).toList(),
          };
        }).toList(),
      };

      await HttpHelper.put("item/update-schedule/$id", data);

    } catch (error) {
      print("Error in updateScheduleItem: $error");
      rethrow;
    }
  }
}
