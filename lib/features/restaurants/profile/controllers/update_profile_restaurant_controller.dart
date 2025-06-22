import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:food_delivery_h2d/data/update_profile/update_profile_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/models/profile_restaurant_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UpdateProfileRestaurantController extends GetxController {
  static UpdateProfileRestaurantController get instance => Get.find();

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  final isLoading = false.obs;
  final _repository = UpdateProfileRepository();

  final picker = ImagePicker();
  late String provinceName;
  late String districtName;
  late String communeName;
  final _addressRepository = Get.put(AddressRepository());

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  String get address {
    return "${LoginController.instance.currentUser.detailAddress}, $communeName, $districtName, $provinceName";
  }

  Future fetchData() async {
    try {
      isLoading.value = true;
      await _fetchProvinceName();
      await _fetchDistrictName();
      await _fetchCommunes();
      addressController.text = address;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchProvinceName() async {
    try {
      final provinces = await _addressRepository.getProvinces();
      provinceName = provinces
          .firstWhere((province) =>
              province.id == LoginController.instance.currentUser.provinceId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchDistrictName() async {
    try {
      final districts = await _addressRepository
          .getDistrict(LoginController.instance.currentUser.provinceId);
      districtName = districts
          .firstWhere((district) =>
              district.id == LoginController.instance.currentUser.districtId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchCommunes() async {
    try {
      final communes = await _addressRepository
          .getCommunes(LoginController.instance.currentUser.districtId);

      communeName = communes
          .firstWhere((commune) =>
              commune.id == LoginController.instance.currentUser.communeId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }

  Rxn<File> avatarImage = Rxn<File>();
  Rxn<File> storeFrontImage = Rxn<File>();

  Future<void> pickImage({required bool isAvatar}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (isAvatar) {
        avatarImage.value = file;
      } else {
        storeFrontImage.value = file;
      }
    }
  }

  Future<void> submitUpdateRequest() async {
    try {
      FullScreenLoader.openDialog("Đang xử lý", MyImagePaths.spoonAnimation);

      final updatedProfile = ProfileRestaurant(
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        email: emailController.text,
        address: addressController.text,
        description: descriptionController.text,
      );

      List<http.MultipartFile> files = [];

      if (avatarImage.value != null) {
        files.add(await http.MultipartFile.fromPath(
          'avatarUrl',
          avatarImage.value!.path,
          filename: basename(avatarImage.value!.path),
        ));
      }

      if (storeFrontImage.value != null) {
        files.add(await http.MultipartFile.fromPath(
          'storeFront',
          storeFrontImage.value!.path,
          filename: basename(storeFrontImage.value!.path),
        ));
      }

      await _repository.submitUpdateRequest(
        partnerId: LoginController.instance.currentUser.userId,
        updatedPartner: updatedProfile,
        files: files,
      );
      avatarImage.value = null;
      storeFrontImage.value = null;

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
