import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/restaurants/notification_restaurant/views/widgets/notification_restaurant_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class NotificationRestaurantScreen extends StatelessWidget {
  const NotificationRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: const CustomAppBar(
        title: Text("Thông báo"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const NotificationRestaurantTile();
        },
      ),
    );
  }
}