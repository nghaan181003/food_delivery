import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:food_delivery_h2d/data/authentication/auth_repository.dart';
import 'package:food_delivery_h2d/features/authentication/models/DriverModel.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/OTP_verification_screen.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/helpers/image_compression.dart';
import 'package:food_delivery_h2d/utils/helpers/multiple_part_file.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;

class DriverRegisterController extends GetxController {
  static DriverRegisterController get instance => Get.find();

  // Repository
  final _addressRepository = Get.put(AddressRepository());

  // TextEdit Controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumbController = TextEditingController();
  final passwordController = TextEditingController();
  final detailAddressController = TextEditingController();
  final licensePlateController = TextEditingController();

  // Address
  var provinces = [].obs;
  var districts = [].obs;
  var communes = [].obs;

  var selectedProvinceId = "".obs;
  var selectedDistrictId = "".obs;
  var selectedCommuneId = "".obs;

  var lenghtDetailAddress = RxInt(0);

  // Images
  var licenseFrontPlateImage = Rx<File?>(null);
  var licenseBackPlateImage = Rx<File?>(null);

  //Loading
  final isLoading = false.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    try {
      isLoading.value = true;
      await fetchProvinces();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    phoneNumbController.dispose();
    passwordController.dispose();
    detailAddressController.dispose();
    provinces.clear();
    districts.clear();
    communes.clear();

    Get.delete<DriverRegisterController>();

    super.onClose();
  }

  void updateSelectedProvinceId(String value) {
    selectedProvinceId.value = value;
    fetchDistricts(value);
    selectedDistrictId.value = "";
    selectedCommuneId.value = "";
  }

  void updateSelectedDistrictId(String value) {
    selectedDistrictId.value = value;
    fetchCommunes(value);
    selectedCommuneId.value = "";
  }

  void updateSelectedCommuneId(String value) {
    selectedCommuneId.value = value;
  }

  void handleDetailAddressChange(String value) {
    lenghtDetailAddress.value = value.length;
  }

  Future<void> fetchProvinces() async {
    try {
      provinces.assignAll(await _addressRepository.getProvinces());
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchDistricts(String idProvince) async {
    try {
      districts.assignAll(await _addressRepository.getDistrict(idProvince));
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCommunes(String idDistrict) async {
    try {
      communes.assignAll(await _addressRepository.getCommunes(idDistrict));
    } catch (e) {
      print(e);
    }
  }

  Future pickImage(Rx<File?> imageFile) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File originalFile = File(pickedImage.path);

      // Display the original image immediately
      imageFile.value = originalFile;
      print('Original Image Path: ${originalFile.path}');
      int originalSize = await originalFile.length();
      print(
          'Original Image Size: $originalSize bytes (${(originalSize / 1024).toStringAsFixed(2)} KB)');

      // Compress image in a separate isolate
      try {
        String? compressedPath = await compute(
            compressImage, CompressImageParams(originalFile.path, 100));

        if (compressedPath != null) {
          File compressedFile = File(compressedPath);
          int compressedSize = await compressedFile.length();
          print('Compressed Image Path: $compressedPath');
          print(
              'Compressed Image Size: $compressedSize bytes (${(compressedSize / 1024).toStringAsFixed(2)} KB)');

          // Update with compressed image
          imageFile.value = compressedFile;
        } else {
          print("Failed to compress image, keeping original file");
        }
      } catch (e) {
        print("Error in compute: $e");
        // Keep original file if compression fails
      }
    } else {
      print("No image selected");
    }
  }

  Future register() async {
    final newDriver = getDriverFromForm();
    var fields = [
      {'fieldName': 'profileUrl', 'file': licenseFrontPlateImage.value},
      {'fieldName': 'licenseFrontUrl', 'file': licenseFrontPlateImage.value},
      {'fieldName': 'licenseBackUrl', 'file': licenseBackPlateImage.value},
    ];
    try {
      FullScreenLoader.openDialog("Đang xử lý", MyImagePaths.spoonAnimation);

      List<http.MultipartFile> files = [];

      files = await MultiplePartFileHelper.createMultipleFiles(fields);

      // Print details of the files
      for (var file in files) {
        print('File Field Name: ${file.field}');
        print('File Path: ${file.filename}');
        print('File Size: ${file.length} bytes');
      }

      // await AuthRepository.instance.registerDriver(newDriver);
      await AuthRepository.instance.registerDriver(newDriver, files);

      // registeredUser.printInfo();
      Loaders.successSnackBar(title: "Đăng ký thành công!");
    } catch (error) {
      Loaders.errorSnackBar(title: "Lỗi!", message: error.toString());
    } finally {
      FullScreenLoader.stopLoading();

      // Clean up temporary files
      for (var field in fields) {
        if (field['file'] != null) {
          await cleanUpCompressedFile(field['file'] as File);
        }
      }

      Get.to(() => OtpVerificationScreen(
            emailAddress: emailController.text,
            role: UserRole.driver.name.toString(),
          ));
    }
  }

  DriverModel getDriverFromForm() {
    return DriverModel(
        driverId: '',
        licensePlate: licensePlateController.text,
        profileUrl: '',
        licenseFrontUrl: '',
        licenseBackUrl: '',
        provinceId:
            AddressSelectionController.instance.selectedProvinceId.value,
        districtId:
            AddressSelectionController.instance.selectedDistrictId.value,
        communeId: AddressSelectionController.instance.selectedCommuneId.value,
        detailAddress:
            AddressSelectionController.instance.detailAddressController.text,
        userId: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        status: false,
        role: UserRole.driver.name,
        phone: phoneNumbController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
  }
}
