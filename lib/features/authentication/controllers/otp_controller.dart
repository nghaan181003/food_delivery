import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/authentication/auth_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/login_screen.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class OtpController {
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  String returnOTP() {
    return controllers.map((controller) => controller.text).join('');
  }

  void verifyOTP(String email, String role) async {
    try {
      final message =
          await AuthRepository.instance.verifyOTP(email, returnOTP(), role);
      Loaders.successSnackBar(title: message);

      Get.offAll(() => const LoginScreen());
    } catch (_) {
      Loaders.errorSnackBar(title: "Mã OTP không tồn tại!");
    }
  }

  Future<bool> resendOTP(String email, String role) async {
    try {
      final res = await AuthRepository.instance.resendOTP(email, role);
      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: email, message: res.message);
        return false;
      }
      Loaders.successSnackBar(title: res.message);
      return true;
    } catch (e) {
      Loaders.errorSnackBar(title: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String email, String role) async {
    try {
      final res = await AuthRepository.instance.resetPassword(email, role);
      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: email, message: res.message);
        return false;
      }
      Loaders.successSnackBar(title: res.message);
      return true;
    } catch (e) {
      Loaders.errorSnackBar(title: e.toString());
      return false;
    }
  }
}
