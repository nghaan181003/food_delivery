import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/pagination_response.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/models/daily_order_model.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/models/order_status_chart.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/order_model.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/daily_revenue.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  Future<List<Order>> getAllOrders() async {
    try {
      final res = await HttpHelper.get("order");
      if (res["hasError"] == true) {
        throw Exception(res["message"]);
      }
      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<Order>> getOrdersByStatus({String? driverStatus}) async {
    try {
      String url = "order/orders/status";
      if (driverStatus != null) {
        url += "?status=$driverStatus";
      }

      final response = await HttpHelper.get(url);
      List<dynamic> data = response['data'] as List<dynamic>;

      return data.map((item) => Order.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches all orders for a specific customer.
  Future<List<Order>> getOrdersByCustomerID(String customerId,
      {List<String>? custStatus}) async {
    try {
      final url = custStatus != null && custStatus.isNotEmpty
          ? "order/customer/$customerId?custStatus=${custStatus.join(',')}"
          : "order/customer/$customerId";

      final res = await HttpHelper.get(url);
      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  /// Places a new order.
  Future<ApiResponse<Order>> placeOrder(OrderModel newOrder) async {
    try {
      final res = await HttpHelper.post("order", newOrder.toJson());
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Order.fromJson(res["data"]);
      print('result: $result');
      Get.back();
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updateOrderStatus(
    String? orderId,
    String? driverId,
    Map<String, dynamic>? statusUpdates,
    String? reason,
  ) async {
    try {
      final updatedStatus = {
        ...?statusUpdates,
        "assignedShipperId": driverId,
        "reason": reason,
      };
      final res = await HttpHelper.patch(
        "order/$orderId/status",
        updatedStatus,
      );

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final result = Order.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updateOrderStatusWithDriverLocation(
    String orderId,
    String? driverId,
    Map<String, dynamic> statusUpdates,
    Map<String, dynamic>? driverLocation,
  ) async {
    try {
      final updatedStatus = {
        ...statusUpdates,
        "assignedShipperId": driverId,
        if (driverLocation != null) "driverLat": driverLocation['latitude'],
        if (driverLocation != null) "driverLng": driverLocation['longitude'],
      };
      final res = await HttpHelper.patch(
        "order/$orderId/status",
        updatedStatus,
      );

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final result = Order.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updateDriverLocation(
    String orderId,
    double driverLat,
    double driverLng,
    String timestamp,
  ) async {
    try {
      final payload = {
        "driverLat": driverLat,
        "driverLng": driverLng,
        "timestamp": timestamp,
      };
      final res = await HttpHelper.patch(
        "order/$orderId/location",
        payload,
      );

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final result = Order.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print("Error updating driver location: $e");
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updatePaymentStatus(String orderId) async {
    try {
      final updateData = {"paymentStatus": "paid"};
      final res = await HttpHelper.patch("order/$orderId/payment", updateData);

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final updatedOrder = Order.fromJson(res["data"]);
      return ApiResponse.completed(
          updatedOrder, "Payment status updated successfully.");
    } catch (e) {
      print("Error updating payment status: $e");
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updateCustAddress(
    String? orderId,
    String? newAddress,
    double? custLat,
    double? custLng,
  ) async {
    try {
      final body = {
        "custAddress": newAddress,
        "custLat": custLat,
        "custLng": custLng,
      };

      print("order/$orderId/address");
      print(body);

      final res = await HttpHelper.patch(
        "order/$orderId/address",
        body,
      );

      if (res == null || res["hasError"] == true) {
        return ApiResponse.error(res?["message"] ?? "Unknown error");
      }

      if (res["data"] == null) {
        return ApiResponse.error("Order update failed: Data is null");
      }

      final result = Order.fromJson(res["data"] as Map<String, dynamic>);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print("Error: $e");
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  /// Deletes an order by its ID.
  Future<ApiResponse<String>> deleteOrder(String orderId) async {
    try {
      final res = await HttpHelper.delete("order/${orderId.toString()}");
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(orderId, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  /// Fetches a specific order by its ID.
  Future<ApiResponse<Order>> getOrderById(String id) async {
    try {
      final res = await HttpHelper.get("order/$id");

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final order = Order.fromJson(res["data"]);
      print(order);
      return ApiResponse.completed(order, res["message"]);
    } catch (e) {
      print(e); // Debug unexpected errors
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<List<Order>> getOrdersByDriverId(String driverId,
      {List<String>? driverStatus}) async {
    try {
      final url = driverStatus != null && driverStatus.isNotEmpty
          ? "order/driver/$driverId?driverStatus=${driverStatus.join(',')}"
          : "order/driver/$driverId";
      final response = await HttpHelper.get(url);

      if (response["hasError"] == true) {
        throw Exception(response["message"]);
      }

      final list = (response["data"] as List)
          .map((order) => Order.fromJson(order))
          .toList();
      return list;
    } catch (e) {
      print("Error fetching orders by driver ID: $e");
      rethrow;
    }
  }

  Future<PaginationResponse<List<Order>>> getOrdersByPartnerStatus(
      String partnerId, List<String> statusList,
      {int page = 1, int limit = 5}) async {
    try {
      final statusParam = statusList.join(',');

      final res = await HttpHelper.get(
          "order/orders/partner?partnerId=$partnerId&status=$statusParam&page=$page&limit=$limit");

      if (res["status"] == "error") {
        print("Error Message: ${res["message"]}");
        return PaginationResponse.error(res["message"]);
      }

      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();

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

  Future<ApiResponse<Order>> updateRating(String orderId, double custResRating,
      {String? custResRatingComment,
      double? custShipperRating,
      String? custShipperRatingComment}) async {
    try {
      final Map<String, dynamic> payload = {
        "custResRating": custResRating,
        "custResRatingComment": custResRatingComment,
        "custShipperRating": custShipperRating,
        "custShipperRatingComment": custShipperRatingComment,
      };

      final res = await HttpHelper.patch(
        "order/rating/${orderId.toString()}",
        payload,
      );

      print("Update rating response: ${res.toString()}");

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final result = Order.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print("Error in updateRating: $e");
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<OrderStatusChartModel> fetchStatistic() async {
    try {
      final response = await HttpHelper.get("order/admin/statistics");

      var data = response['data'];

      return OrderStatusChartModel.fromJson(data);
    } on Exception catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<PaginationResponse<List<Order>>> getAllOrderInAdmin(
      {int page = 1, int limit = 6}) async {
    try {
      final res = await HttpHelper.get("order?page=$page&limit=$limit");
      if (res["status"] == "error") {
        print("Error Message: ${res["message"]}");
        return PaginationResponse.error(res["message"]);
      }

      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();
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

  Future<PaginationResponse<List<Order>>> getOrderByStatus(
      {int page = 1, int limit = 6, String? status}) async {
    try {
      final res = await HttpHelper.get(
          "order/admin/status?page=$page&limit=$limit&status=$status");
      if (res["status"] == "error") {
        print("Error Message: ${res["message"]}");
        return PaginationResponse.error(res["message"]);
      }

      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();
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

  Future<PaginationResponse<List<Order>>> searchOrderById(
      {int page = 1, int limit = 6, String? id}) async {
    try {
      final res = await HttpHelper.get(
          "order/admin/search?page=$page&limit=$limit&id=$id");
      if (res["status"] == "error") {
        print("Error Message: ${res["message"]}");
        return PaginationResponse.error(res["message"]);
      }

      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();
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

  Future<ApiResponse<Map<String, dynamic>>> calcDeliveryFee({
    required double? customerLat,
    required double? customerLng,
    required String? restaurantId,
  }) async {
    try {
      // Validate input
      if (customerLat == null ||
          customerLng == null ||
          restaurantId == null ||
          restaurantId.isEmpty) {
        return ApiResponse.error(
            "Missing required fields: customerLat, customerLng, or restaurantId");
      }

      if (customerLat == 0.0 || customerLng == 0.0) {
        return ApiResponse.error(
            "Invalid coordinates: latitude and longitude must be non-zero");
      }

      final res = await HttpHelper.post(
        "order/calculate-delivery-fee",
        {
          "customerLat": customerLat,
          "customerLng": customerLng,
          "restaurantId": restaurantId,
        },
      );

      if (res["status"] != 200) {
        final errorMessage = res["errorCode"] == "INVALID_CONFIG"
            ? "Delivery fee configuration is invalid"
            : res["message"] ?? "Failed to calculate delivery fee";
        return ApiResponse.error(errorMessage);
      }

      // Validate response data
      if (res["data"] == null ||
          res["data"]["distance"] == null ||
          res["data"]["deliveryFee"] == null) {
        return ApiResponse.error("Invalid response data from server");
      }

      final Map<String, dynamic> data = {
        "distance": (res["data"]["distance"] as num?)?.toDouble() ?? 0.0,
        "deliveryFee": (res["data"]["deliveryFee"] as num?)?.toDouble() ?? 0.0,
      };

      return ApiResponse.completed(
        data,
        res["message"] ?? "Calculate delivery fee successfully",
      );
    } catch (e) {
      final errorMessage = e.toString().contains("SocketException")
          ? "Network error: Please check your internet connection"
          : "Failed to calculate delivery fee: $e";
      return ApiResponse.error(errorMessage);
    }
  }

  Future<ApiResponse<Order>> deleteOrderById(
    String id,
  ) async {
    try {
      final res = await HttpHelper.patch("order/delete/$id");

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      if (res["data"] == null) {
        return ApiResponse.completed(null, res["message"]);
      }

      return ApiResponse.completed(
        Order.fromJson(res["data"]),
        res["message"],
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<List<DailyRevenueModel>> fetchDailyRevenueInAdmin(
      int month, int year) async {
    try {
      final res = await HttpHelper.get(
          "order/admin/top_revenue?month=$month&year=$year");
      List<dynamic> data = res['data'] as List<dynamic>;
      return data.map((item) => DailyRevenueModel.fromJson(item)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<DailyOrderModel>> fetchDailyOrderInAdmin(
      int month, int year) async {
    try {
      final res = await HttpHelper.get(
          "order/admin/daily_order?month=$month&year=$year");
      List<dynamic> data = res['data'] as List<dynamic>;
      return data.map((item) => DailyOrderModel.fromJson(item)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<bool>> rejectSuggestionOrder(
      {required String orderId, required String driverId}) async {
    try {
      final res = await HttpHelper.post(
          'order/$orderId/reject', {"driverId": driverId});

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      return ApiResponse.completed(true, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<bool>> acceptSuggestionOrder(
      {required String orderId, required String driverId}) async {
    try {
      final res = await HttpHelper.post(
          'order/$orderId/accept_suggestion', {"driverId": driverId});

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      return ApiResponse.completed(true, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
