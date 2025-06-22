import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_h2d/common/widgets/header/primary_header.dart';
import 'package:food_delivery_h2d/common/widgets/loaders/animated_digit.dart';
import 'package:food_delivery_h2d/features/notification/controllers/notification_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/home/widgets/home_menu_item.dart';
import 'package:food_delivery_h2d/features/restaurants/home/widgets/restaurant_home_appbar.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/controllers/profile_restaurant_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/income_home_controller.dart';
import 'package:food_delivery_h2d/features/wallet/controllers/wallet_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class RestaurantHomeScreen extends StatefulWidget {
  const RestaurantHomeScreen({super.key});

  @override
  State<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  late final Ticker _ticker;
  int _loadingAnimationValue = 0;
  final statisticController = Get.put(IncomeHomeController());
  final notificationController = Get.put(NotificationController());
  final walletController = Get.put(WalletController());
  final profileController = Get.put(ProfileRestaurantController());

  Future<void> _onRefresh() async {
    await statisticController.fetchIncomeFromStartDay();
    await walletController.fetchWallet();
    await notificationController.fetchNotifications();
    await profileController.refreshProfile();

  }

  @override
  void initState() {
    super.initState();
    _ticker = Ticker((elapsed) {
      if (statisticController.isLoading.value) {
        setState(() {
          _loadingAnimationValue++;
        });
      } else {
        _ticker.stop();
        _loadingAnimationValue = 0;
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget _buildRevenue(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(MySizes.defaultSpace),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySizes.sm),
          color: MyColors.white.withOpacity(0.2),
        ),
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tổng doanh thu",
              style: textTheme.titleLarge!.copyWith(color: MyColors.white),
            ),
            Obx(() {
              final isLoading = statisticController.isLoading.value;
              final value = isLoading
                  ? (_loadingAnimationValue % 999 + 1000).toDouble()
                  : statisticController.totalIncome.toDouble();
              return AnimatedDigitCounter(value: value);
            }),
            const SizedBox(height: MySizes.sm),
            Text(
              "Lượt giao dịch",
              style: textTheme.titleLarge!.copyWith(color: MyColors.white),
            ),
            Obx(() {
              final isLoading = statisticController.isLoading.value;
              final value = isLoading
                  ? (_loadingAnimationValue % 999 + 2).toDouble()
                  : walletController.transactions.length.toDouble();
              return AnimatedDigitCounter(
                  value: value, isFormatedCurrency: false);
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: MySizes.defaultSpace),
          children: [
            MyPrimaryHeaderContainer(
              child: Column(
                children: [
                  const RestaurantHomeAppbar(),
                  _buildRevenue(context),
                  const SizedBox(height: MySizes.defaultSpace),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: MySizes.defaultSpace),
              child: GridView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: MySizes.spaceBtwItems,
                  crossAxisSpacing: MySizes.spaceBtwItems,
                  childAspectRatio: 0.9,
                ),
                children: HomeRestaurant.values.map((e) => e.toWidget).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
