import 'package:flutter/cupertino.dart';
import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/user/user_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class UpdateProfileCustomerController extends GetxController {
  static UpdateProfileCustomerController get instance => Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final userRepository = Get.put(UserRepository());
  var isLoading = true.obs;

  Future<void> updateUser(String userId) async {
    try {
      FullScreenLoader.openDialog("Đang xử lý...", MyImagePaths.spoonAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }
      final updateData = {
        "name": nameController.text.toString().trim(),
        "email": emailController.text.toString().trim(),
        "phone": phoneNumberController.text.toString().trim(),
      };

      await userRepository.updateUser(userId, updateData);
      final updatedUser = LoginController.instance.currentUser.copyWith(
        name: updateData['name'],
        phone: updateData['phone'],
      );

      LoginController.instance.saveUser(updatedUser); 

      Get.back();
      Loaders.successSnackBar(
          title: "Thành công!", message: "Chỉnh sửa thành công");
    } catch (e) {
      Loaders.errorSnackBar(title: "Oops", message: e.toString());
      print('error $e');
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
