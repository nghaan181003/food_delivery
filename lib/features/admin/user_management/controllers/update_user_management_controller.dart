import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/user/user_repository.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/controllers/user_management_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class UpdateUserManagementController extends GetxController {
  static UpdateUserManagementController get instance => Get.find();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  
  RxString roleController = "".obs;

  RxBool isLoading = false.obs;
  final UserRepository userRepository = Get.put(UserRepository());
  final UserManagementController userManagementController = Get.put(UserManagementController());

  Future<void> updateUser(String userId, BuildContext context) async {
    try {
      FullScreenLoader.openDialog("Đang xử lý...", MyImagePaths.spoonAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      final roleEnum = ConvertEnumRole.toEnum(roleController.value); 

      final updateData = {
        "name": nameController.text.toString().trim(),
        "email": emailController.text.toString().trim(),
        "phone": phoneNumberController.text.toString().trim(),
        "role": roleEnum.toString().split('.').last,
      };

      await userRepository.updateUser(userId, updateData);
      userManagementController.fetchAllUsers();
      Loaders.successSnackBar(
          title: "Thành công!", message: "Chỉnh sửa thành công");

      Navigator.of(context).pop();
    } catch (e) {
      Loaders.errorSnackBar(title: "Oops", message: e.toString());
      print('error $e');
    } finally {
      isLoading.value = false;
    }
  }
  void deleteUser(String id) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(MySizes.md),
      title: "Chắc chắn xóa",
      middleText: "Bạn chắc chắn xóa người dùng này",
      confirm: ElevatedButton(
        onPressed: () async {
          await userRepository.deleteUser(id);
          userManagementController.fetchAllUsers(); 
          Navigator.of(Get.overlayContext!).pop();

          Loaders.successSnackBar(
              title: "Thành công!", message: "Xóa thành công");
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: MyColors.darkPrimaryTextColor,
          side: const BorderSide(color: MyColors.darkPrimaryTextColor),
        ),
        child: const Text("Xóa"),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: MySizes.md, vertical: 0),
        ),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text("Quay lại"),
      ),
    );
  }
}
