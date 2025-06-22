import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/arrange_category/widgets/arrange_category_tile.dart';
import 'package:get/get.dart';

class ArrangeCategoryScreen extends StatelessWidget {
  const ArrangeCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuFoodController = Get.put(MenuFoodController());

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Sắp xếp vị trí danh mục"),
      ),
      body: Obx(
        () => ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            menuFoodController.reorderCategories(oldIndex, newIndex);
          },
          children: [
            for (int index = 0; index < menuFoodController.allCategories.length; index++)
              ArrangeCategoryTile(
                key: ValueKey(menuFoodController.allCategories[index].categoryId), 
                category: menuFoodController.allCategories[index],
              ),
          ],
        ),
      ),
    );
  }
}
