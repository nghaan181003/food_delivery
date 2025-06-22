import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/primary_header.dart';
import 'package:food_delivery_h2d/features/customers/home/item_home_search_screen.dart';
import 'package:food_delivery_h2d/features/customers/home/widgets/customer_appbar.dart';
import 'package:food_delivery_h2d/features/customers/home/widgets/home_search_bar.dart';
import 'package:food_delivery_h2d/features/customers/home/widgets/image_place_holder.dart';
import 'package:food_delivery_h2d/features/customers/home/widgets/item_home.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/famous_restaurant_list/list_famous_restaurant.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/nearby_restaurant_list/nearby_restaurant_list.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/top_item_list/list_top_item.dart';
import 'package:food_delivery_h2d/features/notification/controllers/notification_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: MySizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 190,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 150,
                      child: MyPrimaryHeaderContainer(
                        child: Column(
                          children: [
                            CustomerAppbar(),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                        top: 100, left: 0, right: 0, child: HomeSearchBar()),
                  ],
                ),
              ),
              const ImagePlaceHolder(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MySizes.spaceBtwItems),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: MySizes.spaceBtwItems - 6,
                  mainAxisSpacing: MySizes.spaceBtwItems,
                  children: [
                    ItemHome(
                      image: MyImagePaths.iconRice,
                      title: "Cơm",
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Cơm",
                        );
                      },
                    ),
                    ItemHome(
                      title: "Bún",
                      image: MyImagePaths.iconVermicelli,
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Bún",
                        );
                      },
                    ),
                    ItemHome(
                      image: MyImagePaths.iconPho,
                      title: "Phở",
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Phở",
                        );
                      },
                    ),
                    ItemHome(
                      image: MyImagePaths.iconNoodle,
                      title: "Mì",
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Mì",
                        );
                      },
                    ),
                    ItemHome(
                      image: MyImagePaths.iconSnack,
                      title: "Ăn vặt",
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Ăn vặt",
                        );
                      },
                    ),
                    ItemHome(
                      image: MyImagePaths.iconCake,
                      title: "Bánh ngọt",
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Bánh ngọt",
                        );
                      },
                    ),
                    ItemHome(
                      image: MyImagePaths.iconDrink,
                      title: "Trà sữa",
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Trà sữa",
                        );
                      },
                    ),
                    ItemHome(
                      image: MyImagePaths.iconJuice,
                      title: "Nước ép",
                      onTap: () {
                        Get.to(
                          const ItemHomeSearchScreen(),
                          arguments: "Nước ép",
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: MySizes.md, right: MySizes.md, top: MySizes.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Món ngon bán chạy",
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: MyColors.darkPrimaryTextColor,
                              ),
                        ),
                      ],
                    ),
                    const ListTopItem(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: MySizes.md, right: MySizes.md, top: MySizes.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Nhà hàng có lượt đánh giá cao",
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: MyColors.darkPrimaryTextColor,
                              ),
                        ),
                      ],
                    ),
                    const ListFamousRestaurant(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: MySizes.md, right: MySizes.md, top: MySizes.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Nhà hàng gần bạn",
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: MyColors.darkPrimaryTextColor,
                              ),
                        ),
                      ],
                    ),
                    const ListNearbyRestaurant(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
