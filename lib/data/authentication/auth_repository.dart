import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/authentication/models/DriverModel.dart';
import 'package:food_delivery_h2d/features/authentication/models/LoginResponse.dart';
import 'package:food_delivery_h2d/features/authentication/models/PartnerModel.dart';
import 'package:food_delivery_h2d/features/authentication/models/User.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  static const String _loginApi = "auth/login";
  static const String _registerApi = "auth/register";
  static const String _driverRegisterApi = "auth/driverRegister";
  static const String _partnerRegisterApi = "auth/partnerRegister";
  static const String _verifyOTPApi = "auth/verifyOTP";
  static const String _resendOTPApi = "auth/resendOTP";
  static const String _resetPasswordApi = "auth/resetPassword";
  static const String _changePasswordApi = "auth/changePassword";

  Future<LoginResponse> login(
      String email, String password, String role) async {
    final data = {'email': email, 'password': password, 'role': role};
    try {
      final res = await HttpHelper.post(_loginApi, data);
      final loginResponse = LoginResponse.fromJson(res["data"]);
      return loginResponse;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<LoginResponse>> testLogin(
      String email, String password, String role) async {
    final data = {'email': email, 'password': password, 'role': role};
    try {
      final res = await HttpHelper.post(_loginApi, data);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final loginResponse = LoginResponse.fromJson(res["data"]);
      return ApiResponse.completed(loginResponse, res["message"]);
    } catch (e) {
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<UserModel>> register(UserModel newUser) async {
    final data = newUser.toJson();
    try {
      final res = await HttpHelper.post(_registerApi, data);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final newUser = UserModel.fromJson(res["data"]);
      return ApiResponse.completed(newUser, res["message"]);
    } catch (e) {
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<void> registerDriver(
      DriverModel newDriver, List<http.MultipartFile> files) async {
    try {
      final res = await HttpHelper.postWithFiles(
          _driverRegisterApi, newDriver.toJson(), files);
      //print(res);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> registerPartner(
      PartnerModel newPartner, List<http.MultipartFile> files) async {
    try {
      print("Registering partner with data: ${newPartner.toJson()}");
      final res = await HttpHelper.postWithFiles(
          _partnerRegisterApi, newPartner.toJson(), files);
      //print(res);
      print(newPartner.toJson());
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<String> verifyOTP(String email, String otp, String role) async {
    final data = {
      "email": email,
      "otp": otp,
      "role": role,
    };
    try {
      final res = await HttpHelper.post(_verifyOTPApi, data);
      return res["message"];
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<String>> resendOTP(String email, String role) async {
    final data = {"email": email, "role": role};
    try {
      final res = await HttpHelper.post(_resendOTPApi, data);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed("", res["message"]);
    } catch (e) {
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<String>> resetPassword(String email, String role) async {
    final data = {"email": email, "role": role};
    try {
      final res = await HttpHelper.post(_resetPasswordApi, data);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed("", res["message"]);
    } catch (e) {
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<String>> changePassword(
      String id, String oldPassword, String newPassword) async {
    final data = {
      "id": id,
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };
    try {
      final res = await HttpHelper.post(_changePasswordApi, data);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed("", res["message"]);
    } catch (e) {
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  // void sendOTP(String email) async {
  //   final data = {"email": email};
  //   try {
  //     await HttpHelper.post(_sendOTPApi, data);
  //   } on Exception catch (_) {
  //     rethrow;
  //   }
  // }
}
