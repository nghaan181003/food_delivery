import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/detail_restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/detail_partner_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/widgets/menu_restaurant_rating.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class DetailRestaurantScreen extends StatelessWidget {
  final String userId;

  const DetailRestaurantScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailRestaurantController());
    final restaurantController = Get.put(RestaurantController());
    controller.fetchDetailPartner(userId);
    final partner = Get.arguments as DetailPartnerModel?;
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Thông tin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner!.userId.name,
                  style: const TextStyle(
                    color: MyColors.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: MySizes.sm),
                InkWell(
                  onTap: () {
                    Get.to(MenuRestaurantRating(
                          userId: userId,
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingStars(
                        axis: Axis.horizontal,
                        value: restaurantController.value.value,
                        starCount: 5,
                        starSize: 12,
                        maxValue: 5,
                        starSpacing: 2,
                        maxValueVisibility: true,
                        valueLabelVisibility: false,
                        valueLabelPadding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 8),
                        valueLabelMargin: const EdgeInsets.only(right: 8),
                        starOffColor: MyColors.starOffColor,
                        starColor: MyColors.starColor,
                        angle: 12,
                      ),
                      const SizedBox(width: MySizes.xs),
                      Padding(
                        padding: const EdgeInsets.only(top: MySizes.xs / 2),
                        child: Text(
                          MyFormatter.formatDouble(restaurantController.value.value),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: MyColors.primaryTextColor),
                        ),
                      ),
                      const SizedBox(width: MySizes.sm),
                      Container(
                        color: MyColors.dividerColor,
                        width: 0.8,
                        height: 15,
                      ),
                      const SizedBox(width: MySizes.sm),
                      Padding(
                        padding: const EdgeInsets.only(top: MySizes.xs / 2),
                        child: Text(
                          "${restaurantController.ratingList.length} đánh giá",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: MyColors.primaryTextColor),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: MySizes.xs),
                        child:
                            Icon(Icons.arrow_forward_ios, size: MySizes.iconXs),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: MySizes.md, left: MySizes.md, right: MySizes.md),
                  child: Divider(color: MyColors.dividerColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.near_me_rounded,
                        color: MyColors.primaryTextColor, size: MySizes.iconMd),
                    const SizedBox(width: MySizes.sm),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                          width: 290,
                          child: Text(
                            controller.address,
                            maxLines: 3,
                          ));
                    }),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: MySizes.sm, left: MySizes.md, right: MySizes.md, bottom: MySizes.sm),
                  child: Divider(color: MyColors.dividerColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_iphone_rounded,
                        color: MyColors.primaryTextColor, size: MySizes.iconMs),
                    const SizedBox(width: MySizes.md),
                    Text(restaurantController.detailPartner.value!.userId.phone),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
