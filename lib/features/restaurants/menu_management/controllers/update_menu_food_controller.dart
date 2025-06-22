import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_text.dart';
import 'package:food_delivery_h2d/utils/helpers/multiple_part_file.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class UpdateMenuFoodController extends GetxController {
  static UpdateMenuFoodController get instance => Get.find();
  var isEditting = false.obs;
  var isAdd = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var foodImage = Rx<File?>(null);
  var selectedCaterory = Rxn<String>();
  var keySearch = Rxn<String>("");

  GlobalKey<FormState> itemFormKey = GlobalKey<FormState>();

  // Repository
  final _itemRepository = Get.put(ItemRepository());

  var updatedItemId = "";

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
  }

  void toggleEditting() {
    isEditting.value = !isEditting.value;
    if (!isEditting.value) {
      isAdd.value = false;
    }
  }

  Future save() async {
    if (!itemFormKey.currentState!.validate()) {
      return;
    }
    if (selectedCaterory.value == null) {
      Loaders.errorSnackBar(
          title: "Lỗi", message: "Món ăn chưa thuộc danh mục nào!");
      return;
    }

    final newItem = getItemFromForm();

    if (isAdd.value) {
      _handleAddItem(newItem);
      isAdd.value = false;
    } else {
      _handleUpdateItem(newItem);
    }
  }

  Future _handleUpdateItem(Item oldItem) async {
    try {
      FullScreenLoader.openDialog("Đang xử lý", MyImagePaths.spoonAnimation);
      List<http.MultipartFile> files = [];
      if (foodImage.value != null) {
        var fields = [
          {'fieldName': 'itemImage', 'file': foodImage.value},
        ];
        files = await MultiplePartFileHelper.createMultipleFiles(fields);
      }

      final res = await _itemRepository.updateItem(oldItem, files);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }

      Get.back();
      Loaders.successSnackBar(title: "Thành công", message: res.message);
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future _handleAddItem(Item newItem) async {
    try {
      FullScreenLoader.openDialog("Đang xử lý", MyImagePaths.spoonAnimation);
      List<http.MultipartFile> files = [];

      var fields = [
        {'fieldName': 'itemImage', 'file': foodImage.value},
      ];
      files = await MultiplePartFileHelper.createMultipleFiles(fields);
      final res = await _itemRepository.addItem(newItem, files);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }
      // Update to UI
      MenuFoodController.instance.allItems.add(res.data!);
      MenuFoodController.instance.allItems.refresh();
      Get.back();
      Loaders.successSnackBar(title: "Thành công", message: res.message);
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future pickImage(Rx<File?> imageFile) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
    } else {
      print("No image");
    }
  }

  void removeItem(String itemId) async {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(MySizes.md),
        title: "Xóa món ăn",
        middleText: "Bạn có chắc chắn muốn xóa món ăn này!",
        confirm: ElevatedButton(
            onPressed: () async {
              try {
                FullScreenLoader.openDialog(
                    "Đang xử lý...", MyImagePaths.spoonAnimation);

                MenuFoodController.instance.allItems
                    .removeWhere((item) => item.itemId == itemId);

                await _itemRepository.removeItem(itemId);

                Navigator.of(Get.overlayContext!).pop();
                Loaders.successSnackBar(
                    title: "Thành công!", message: "Xóa món ăn");
              } catch (err) {
                Loaders.successSnackBar(
                    title: "Thất bại!", message: "Xóa món ăn");
              } finally {
                FullScreenLoader.stopLoading();
              }
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red)),
            child: const Text("Xóa")),
        cancel: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: MySizes.md, vertical: 0)),
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text("Quay lại")));
  }

  Item getItemFromForm() {
    return Item(
        keySearch: keySearch.value.toString(),
        itemName: nameController.text,
        itemId: updatedItemId,
        categoryId: selectedCaterory.value.toString(),
        itemImage: "",
        price: ConvertText.getTextAsInteger(priceController.text),
        quantity: ConvertText.getTextAsInteger(quantityController.text),
        description: descriptionController.text,
        isAvailable: true,
        partnerId: LoginController.instance.currentUser.partnerId);
  }
}
