import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/category/category_repository.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';

class MenuFoodController extends GetxController {
  static MenuFoodController get instance => Get.find();

  var allItems = <Item>[].obs;

  var isLoading = false.obs;
  var allCategories = <Category>[].obs;

  final _newCategoryController = TextEditingController();

  // Repository
  final CategoryRepository _categoryRepository = Get.put(CategoryRepository());
  final ItemRepository _itemRepository = Get.put(ItemRepository());

  @override
  void onClose() {
    // TODO: implement onClose
    _newCategoryController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    print("INIT");
    // TODO: implement onInit
    await reload();
    super.onInit();
  }

  Future<void> reload() async {
    await fetchCategories();
    await fetchAllItems();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      allCategories.clear();
      allCategories.assignAll(
          await _categoryRepository.getCategoriesInRestaurant(
              LoginController.instance.currentUser.partnerId));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllItems() async {
    try {
      isLoading.value = true;
      allItems.clear();

      final allItemsByCategory = await Future.wait(
        allCategories
            .map((cat) => _itemRepository.getItemsByCategoryID(cat.categoryId)),
      );

      final combinedItems =
          allItemsByCategory.expand((items) => items).toList();

      allItems.assignAll(combinedItems);
    } catch (error) {
      // Handle errors if necessary
      print("Error fetching items: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> removeCategory(String categoryId) async {
    final t = await Get.defaultDialog(
        contentPadding: const EdgeInsets.all(MySizes.md),
        title: "Xóa danh mục",
        middleText: "Bạn có chắc chắn muốn xóa danh mục này!",
        confirm: ElevatedButton(
            onPressed: () async {
              try {
                final result =
                    await _categoryRepository.removeCategoryV2(categoryId);
                if (result.status!.isERROR) {
                  Loaders.errorSnackBar(
                      title: "Thất bại!", message: result.message);
                  Navigator.of(Get.overlayContext!).pop(false);
                  return;
                }
                allCategories
                    .removeWhere((item) => item.categoryId == categoryId);
                Navigator.of(Get.overlayContext!).pop(true);
                Loaders.successSnackBar(
                    title: "Thành công!", message: result.message);
              } catch (err) {
                Loaders.errorSnackBar(title: "Thất bại!", message: err);
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
            onPressed: () => Navigator.of(Get.overlayContext!).pop(false),
            child: const Text("Quay lại")));

    return t;
  }

  void toggleItemAvailability(Item item) async {
    item.isAvailable.value = !item.isAvailable.value; // switch status
    await _itemRepository.updateItem(item, []);
  }

  List<Item> getItemsForCategory(String categoryId) {
    return allItems.where((item) => item.categoryId == categoryId).toList();
  }

  void reorderCategories(int oldIndex, int newIndex) async {
    try {
      if (newIndex > oldIndex) newIndex--;

      final category = allCategories.removeAt(oldIndex);
      allCategories.insert(newIndex, category);

      final categoryIds =
          allCategories.map((category) => category.categoryId).toList();
      final res = await _categoryRepository.reorderCategoryIndex(
          LoginController.instance.currentUser.partnerId, categoryIds);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }

      print(res.message);
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
      return;
    }
  }

  Future<bool?> addCategory() async {
    final t = await Get.defaultDialog<bool>(
      contentPadding: const EdgeInsets.all(MySizes.md),
      title: "Thêm danh mục",
      confirm: ElevatedButton(
        onPressed: () async {
          try {
            String categoryName = _newCategoryController.text.trim();
            if (categoryName.isEmpty) {
              Loaders.successSnackBar(
                title: "Thất bại!",
                message: "Tên danh mục không thể trống",
              );
              return;
            }

            final result = await _categoryRepository.addCategoryV2(Category(
                categoryName: categoryName,
                restaurantId: LoginController.instance.currentUser.partnerId));

            if (result.status!.isERROR) {
              Loaders.errorSnackBar(
                title: "Thất bại!",
                message: "${result.message}",
              );
              return;
            }

            if (result.data != null) {
              allCategories.add(result.data!);
              _newCategoryController.text = "";

              Navigator.of(Get.overlayContext!).pop(true);

              Loaders.successSnackBar(
                title: "Thành công!",
                message: "Thêm danh mục thành công",
              );
            }
          } catch (err) {
            Loaders.errorSnackBar(
              title: "Thất bại!",
              message: "$err",
            );
          }
        },
        child: const Text("Thêm"),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(false),
        child: const Text("Quay lại"),
      ),
      content: Column(
        children: [
          TextField(
            controller: _newCategoryController,
            decoration: const InputDecoration(
              labelText: "Tên danh mục",
              hintText: "Nhập tên danh mục",
            ),
          ),
        ],
      ),
    );

    return t;
  }

  void remove(int index) {
    allCategories.removeAt(index);
  }

  Future save() async {
    try {
      FullScreenLoader.openDialog("Đang lưu...", MyImagePaths.spoonAnimation);
      for (var cat in allCategories) {
        final index = allCategories
            .indexWhere((item) => item.categoryId == cat.categoryId);
        final updatedCategory = await _categoryRepository.updateCategory(cat);
        if (index != -1) {
          // Update the category's name
          allCategories[index] = updatedCategory;
          print("Category updated successfully!");
        } else {
          print("Category with ID ${updatedCategory.categoryId} not found!");
        }
      }
    } catch (error) {
      print(error);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
