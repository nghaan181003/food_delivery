import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_restaurant_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/menu_restaurant_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class FamousRestaurantTile extends StatelessWidget {
  final TopRestaurantModel restaurant;

  const FamousRestaurantTile({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(MenuRestaurantScreen(userId: restaurant.restaurantId,));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: MySizes.sm),
        child: Card(
          elevation: 2,
          shadowColor: MyColors.darkPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.only(top: MySizes.md),
            child: Center(
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.restaurantURL,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                  const SizedBox(
                    height: MySizes.sm,
                  ),
                  SizedBox(
                    width: 80,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        restaurant.userName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: MySizes.xs,
                  ),
                  RatingStars(
                    axis: Axis.horizontal,
                    value: restaurant.averageRating,
                    onValueChanged: (v) {},
                    starCount: 5,
                    starSize: 12,
                    maxValue: 5,
                    starSpacing: 4,
                    maxValueVisibility: true,
                    valueLabelVisibility: false,
                    valueLabelPadding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                    valueLabelMargin: const EdgeInsets.only(right: 8),
                    starOffColor: MyColors.starOffColor,
                    starColor: MyColors.starColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
