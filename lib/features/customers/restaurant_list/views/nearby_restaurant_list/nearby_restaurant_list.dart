import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/nearby_restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/nearby_restaurant_list/widgets/nearby_restaurant_tile.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ListNearbyRestaurant extends StatelessWidget {
  const ListNearbyRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = Get.put(NearbyRestaurantController());
    return SizedBox(
      height: 100,
      child: Obx(() {
        if (restaurantController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (restaurantController.restaurantList.isEmpty) {
          return const Center(
              child: Text('Không tìm thấy nhà hàng nào gần bạn'));
        }
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          // physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: MySizes.xs),
          itemCount: restaurantController.restaurantList.length,
          itemBuilder: (context, index) {
            final restaurant = restaurantController.restaurantList[index];
            return SizedBox(
              width: 300,
              child: NearbyRestaurantTile(restaurant: restaurant),
            );
          },
        );
      }),
    );
  }
}
