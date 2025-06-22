import 'package:food_delivery_h2d/data/location/location_%20model.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/authentication/models/DriverModel.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/features/shippers/income/models/income_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class DriverRepository extends GetxController {
  static DriverRepository get instance => Get.find();

  static const String _driverApi = "driver";

  Future<DriverModel> getCurrentDriver(String userId) async {
    try {
      final res = await HttpHelper.get("$_driverApi/${userId.toString()}");
      return DriverModel.fromJson(res["data"]);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> updateDriverStatus(String userId, bool status) async {
    try {
      final data = {
        'status': status,
      };

      final res = await HttpHelper.put("driver/updateStatus/$userId", data);

      if (res["hasError"] == false && res["statusCode"] == 200) {
      } else {
        throw Exception("Failed to update driver status: ${res["message"]}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateDriverLocation(String userId, Position position) async {
    try {
      final data = {
        'location': {
          'type': 'Point',
          'coordinates': [position.longitude, position.latitude],
          'timestamp': position.timestamp.toIso8601String(),
        },
      };
      final res =
          await HttpHelper.put("$_driverApi/updateLocation/$userId", data);
      if (res["hasError"] == false && res["statusCode"] == 200) {
      } else {
        throw Exception("Failed to update driver location: ${res["message"]}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<RatingModel>> fetchDriverRating(String driverId) async {
    try {
      final response = await HttpHelper.get("driver/rating/$driverId");

      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => RatingModel.fromJson(item)).toList();
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<List<IncomeModel>> fetchIncomeDriver(String driverId,
      {String? dateFrom, String? dateTo}) async {
    try {
      String url = "driver/statistic/$driverId";
      if (dateFrom != null && dateTo != null) {
        url += "?query_dateFrom=$dateFrom&query_dateTo=$dateTo";
      }
      final response = await HttpHelper.get(url);

      List<dynamic> data = response['data'] as List<dynamic>;

      return data
          .map<IncomeModel>((json) => IncomeModel.fromJson(json))
          .toList();
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<List<DriverModel>> fetchActiveDrivers() async {
    try {
      final response = await HttpHelper.get("$_driverApi/active");

      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => DriverModel.fromJson(item)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<void>> updateCurrentPosition(
      String driverId, LocationModel data) async {
    try {
      final res = await HttpHelper.patch(
          '$_driverApi/$driverId/location', data.toJson());
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      print("Update current driver position!");
      return ApiResponse.completed(res["data"], res["message"]);
    } catch (e) {
      print("UPDATE CURRENT ${e.toString()}");
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<Order>>> getSuggestionOrderForDriver(
      String driverId) async {
    try {
      final res = await HttpHelper.get("$_driverApi/$driverId/suggestion");

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      final list = (res["data"] as List)
          .map((json) => Order.fromJson(json["order"]))
          .toList();

      return ApiResponse.completed(list, res["message"]);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
