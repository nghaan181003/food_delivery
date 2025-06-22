import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_h2d/data/update_profile/update_profile_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/profile/models/profile_driver_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UpdateProfileDriverController extends GetxController {
  static UpdateProfileDriverController get instance => Get.find();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final licensePlateController = TextEditingController();

  final isLoading = false.obs;
  final _repository = UpdateProfileRepository();

  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
  }

  Rxn<File> profileImage = Rxn<File>();

  Future<void> pickImage({required bool isProfile}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (isProfile) {
        profileImage.value = file;
      } 
    }
  }

  Future<void> createDriveUpdate() async {
    try {
      FullScreenLoader.openDialog("Đang xử lý", MyImagePaths.spoonAnimation);

      final updatedProfile = ProfileDriverModel(
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        licensePlate: licensePlateController.text,
      );

      List<http.MultipartFile> files = [];

      if (profileImage.value != null) {
        files.add(await http.MultipartFile.fromPath(
          'profileUrl',
          profileImage.value!.path,
          filename: basename(profileImage.value!.path),
        ));
      }

      await _repository.createDriveUpdate(
        driverId: LoginController.instance.currentUser.userId,
        updatedDriver: updatedProfile,
        files: files,
      );
      profileImage.value = null;

      Get.back();
      Loaders.successSnackBar(
          title: "Thành công", message: "Gửi yêu cầu cập nhật thành công");
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
