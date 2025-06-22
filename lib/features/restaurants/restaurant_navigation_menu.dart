import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/home/restaurant_home_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/notification_restaurant/views/notification_restaurant_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/views/profile_restaurant_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/views/rating_list/rating_list_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/devices/devices_utils.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class RestaurantNavigationMenu extends StatelessWidget {
  const RestaurantNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final kBottomPadding = MyDeviceUtils.getBottomNavigationBarHeight() * 0.3;
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        color: MyColors.darkPrimaryColor,
        child: Padding(
          padding: EdgeInsets.only(
              left: 4, right: 4, top: 8, bottom: kBottomPadding),
          child: GNav(
            backgroundColor: MyColors.darkPrimaryColor,
            activeColor: Colors.white,
            tabBackgroundColor: MyColors.lightPrimaryColor,
            rippleColor: Colors.white,
            hoverColor: Colors.white,
            gap: 8,
            padding: const EdgeInsets.all(MySizes.defaultSpace / 2),
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                iconColor: Colors.white,
                text: 'Trang chủ',
              ),
              GButton(
                icon: Icons.comment_outlined,
                //icon: Icons.feed_outlined,
                text: 'Đánh giá',
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.notifications_outlined,
                iconColor: Colors.white,
                text: 'Thông báo',
              ),
              // GButton(
              //   icon: Icons.inventory_outlined,
              //   text: 'Đơn hàng',
              //   iconColor: Colors.white,
              // ),
              // GButton(
              //   icon: Icons.fastfood_outlined,
              //   text: 'Thực đơn',
              //   iconColor: Colors.white,
              // ),

              GButton(
                icon: Icons.person_outlined,
                text: 'Tài khoản',
                iconColor: Colors.white,
              ),
            ],
            onTabChange: (index) {
              controller.selectedIndex.value = index;
            },
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    RestaurantHomeScreen(),
    const RatingListScreen(),
    const NotificationRestaurantScreen(),
    const ProfileRestaurantScreen()
  ];
}
