import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/favorite_list_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/favorite_list/widgets/favorite_tile.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteListController());
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Danh sách yêu thích'),
        showBackArrow: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.sm),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // return GridView.builder(
          //   physics: const AlwaysScrollableScrollPhysics(),
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2, 
          //     childAspectRatio: 0.9, 
          //     mainAxisSpacing: MySizes.md,
          //     crossAxisSpacing: MySizes.md,
          //   ),
          //   itemCount: controller.favoriteList.length,
          //   itemBuilder: (context, index) {
          //     final item = controller.favoriteList[index];
          //     return FavoriteTile(item: item);
          //   },
          // );
          return ListView.builder(
            itemCount: controller.favoriteList.length,
            itemBuilder: (context, index) {
            final item = controller.favoriteList[index];
            return FavoriteTile(item: item);
          });
        }),
      ),
    );
  }
}
