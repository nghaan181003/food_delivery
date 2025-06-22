import 'package:food_delivery_h2d/data/response/pagination_response.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/driver_model.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/partner_model.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final response = await HttpHelper.get("user");
      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => UserModel.fromJson(item)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<PaginationResponse<List<UserModel>>> fetchAllUsersInAdmin(
      {int page = 1, int limit = 6}) async {
    try {
      final res = await HttpHelper.get("user/admin/all?page=$page&limit=$limit");

      if (res["status"] == "error") {
        return PaginationResponse.error(res["message"]);
      }

      final list = (res["data"] as List)
          .map((user) => UserModel.fromJson(user))
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

  Future<List<UserModel>> fetchUserByRole({String? role}) async {
    try {
      String url = "user/approve";
      if (role != null && role.isNotEmpty) {
        url += "?role=$role";
      }
      print("Calling API: $url");

      final response = await HttpHelper.get(url);

      final List<dynamic> data = response['data'] ?? [];

      return data.map((item) => UserModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("Error fetching users by role: $e");
      rethrow;
    }
  }

  Future<DriverModel> fetchDriverById(String driverId) async {
    try {
      final response = await HttpHelper.get("driver/$driverId");
      return DriverModel.fromJson(response);
    } on Exception catch (e) {
      print("Error fetching driver by ID: $e");
      rethrow;
    }
  }

  Future<PartnerModel> fetchPartnerById(String partnerId) async {
    try {
      final response = await HttpHelper.get("partner/$partnerId");
      print(response);
      return PartnerModel.fromJson(response);
    } on Exception catch (e) {
      print("Error fetching partner by ID: $e");
      rethrow;
    }
  }

  Future<bool> approveUser(String userId) async {
    try {
      final response = await HttpHelper.put(
        "user/approve/$userId",
      );

      if (response['statusCode'] == 200) {
        return true;
      } else {
        print("Failed to approve user: ${response['message']}");
        return false;
      }
    } on Exception catch (e) {
      print("Error approving user: $e");
      rethrow;
    }
  }

  Future<UserModel> updateUser(
      String userId, Map<String, dynamic> updateData) async {
    try {
      final response = await HttpHelper.put("user/$userId", updateData);
      print(response);

      return UserModel.fromJson(response['data']);
    } on Exception catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final response = await HttpHelper.put(
        "user/delete/$userId",
      );

      if (response['statusCode'] == 200) {
        return true;
      } else {
        print("Failed to approve user: ${response['message']}");
        return false;
      }
    } on Exception catch (e) {
      print("Error approving user: $e");
      rethrow;
    }
  }

  Future<void> deleteApprove(String id) async {
    try {
      await HttpHelper.delete("user/$id");
    } on Exception catch (_) {
      rethrow;
    }
  }
}
