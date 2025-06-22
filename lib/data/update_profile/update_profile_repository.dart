import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/admin/update_request/models/update_request.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/models/profile_restaurant_model.dart';
import 'package:food_delivery_h2d/features/shippers/profile/models/profile_driver_model.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery_h2d/utils/http/http_client.dart';

class UpdateProfileRepository {
  Future<void> submitUpdateRequest({
    required String partnerId,
    required ProfileRestaurant updatedPartner,
    required List<http.MultipartFile> files,
  }) async {
    try {
      final url = "auth/partner/update/$partnerId";

      await HttpHelper.postWithFiles(
        url,
        updatedPartner.toJson(),
        files,
      );
    } catch (e) {
      print('Error submitting update request: $e');
      rethrow;
    }
  }

  Future<List<UpdateRequest>> fetchAllPartnerRequest() async {
    try {
      final response = await HttpHelper.get("auth/update/requests");
      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => UpdateRequest.fromJson(item)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<bool> approvePartnerUpdate(String id) async {
    try {
      final res = await HttpHelper.put("auth/partner/approve/$id");
      if (res['statusCode'] == 200) {
        return true;
      } else {
        print("Failed to approve user: ${res['message']}");
        return false;
      }
    } on Exception catch (e) {
      print("Error approving user: $e");
      rethrow;
    }
  }

  Future<ApiResponse<UpdateRequest>> rejectPartnerUpdateRequest(
    String id,
  ) async {
    try {
      final res = await HttpHelper.delete("auth/partner/reject/$id");

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      if (res["data"] == null) {
        return ApiResponse.completed(null, res["message"]);
      }

      return ApiResponse.completed(
        UpdateRequest.fromJson(res["data"]),
        res["message"],
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<void> createDriveUpdate({
    required String driverId,
    required ProfileDriverModel updatedDriver,
    required List<http.MultipartFile> files,
  }) async {
    try {
      final url = "auth/driver/update/$driverId";

      await HttpHelper.postWithFiles(
        url,
        updatedDriver.toJson(),
        files,
      );
    } catch (e) {
      print('Error submitting update request: $e');
      rethrow;
    }
  }

  Future<List<UpdateRequest>> fetchAllDriverRequest() async {
    try {
      final response = await HttpHelper.get("auth/update/driver/requests");
      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => UpdateRequest.fromJson(item)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<bool> approveDriverUpdate(String id) async {
    try {
      final res = await HttpHelper.put("auth/driver/approve/$id");
      if (res['statusCode'] == 200) {
        return true;
      } else {
        print("Failed to approve user: ${res['message']}");
        return false;
      }
    } on Exception catch (e) {
      print("Error approving user: $e");
      rethrow;
    }
  }

  Future<ApiResponse<UpdateRequest>> rejectDriverUpdateRequest(
    String id,
  ) async {
    try {
      final res = await HttpHelper.patch("auth/driver/reject/$id");

      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }

      if (res["data"] == null) {
        return ApiResponse.completed(null, res["message"]);
      }

      return ApiResponse.completed(
        UpdateRequest.fromJson(res["data"]),
        res["message"],
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
