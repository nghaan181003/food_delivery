import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/home/controllers/home_controller.dart';
import 'package:food_delivery_h2d/features/customers/home/widgets/item_home_search_tile.dart';
import 'package:get/get.dart';

class ItemHomeSearchScreen extends StatelessWidget {
  const ItemHomeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final String title = Get.arguments ?? "";

    homeController.fetchItemSearch(title);

    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        title: Text(title),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (homeController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(homeController.errorMessage.value),
          );
        } else if (homeController.itemSearchList.isEmpty) {
          return const Center(
            child: Text("Không có món ăn này. Vui lòng tìm món khác"),
          );
        } else {
          return ListView.builder(
            itemCount: homeController.itemSearchList.length,
            itemBuilder: (context, index) {
              final item = homeController.itemSearchList[index];
              return ItemHomeSearchTile(item: item);
            },
          );
        }
      }),
    );
  }
}
