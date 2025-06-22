import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/category_list/widgets/category_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuFoodController = Get.put(MenuFoodController());

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Chỉnh sửa danh mục"),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.done,
                size: MySizes.iconMd,
              ),
              onPressed: () {
                menuFoodController.save();
              }),
        ],
      ),
      body: Obx(
        () => menuFoodController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: menuFoodController.allCategories.length,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    category: menuFoodController.allCategories[index],
                    handleDelete: () async {
                      final result = await menuFoodController.removeCategory(
                          menuFoodController.allCategories[index].categoryId);

                      if (result != null && result) {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await menuFoodController.addCategory();

          if (result != null && result) {
            Navigator.of(context).pop();
          }
        },
        backgroundColor: MyColors.darkPrimaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
