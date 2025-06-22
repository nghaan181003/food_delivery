import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/history/views/history_screen.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/shipper_home_screen.dart';
import 'package:food_delivery_h2d/features/shippers/income/views/income_screen.dart';
import 'package:food_delivery_h2d/features/shippers/profile/views/profile_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ShipperNavigationMenu extends StatelessWidget {
  const ShipperNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        color: MyColors.darkPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                icon: Icons.inventory_outlined,
                text: 'Đơn hàng',
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.attach_money,
                iconColor: Colors.white,
                text: 'Thu nhập',
              ),
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
    const ShipperHomeScreen(),
    HistoryScreen(),
    const IncomeScreen(),
    const ProfileScreen(),
  ];
}
