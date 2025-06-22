import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_restaurant_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/menu_restaurant_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class NearbyRestaurantTile extends StatelessWidget {
  final TopRestaurantModel restaurant;

  const NearbyRestaurantTile({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => MenuRestaurantScreen(userId: restaurant.restaurantId));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        ),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              width: 80,
              height: 80,
              // margin: const EdgeInsets.all(MySizes.xs),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MySizes.borderRadiusSm),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MySizes.borderRadiusSm),
                child: CachedNetworkImage(
                  imageUrl: restaurant.restaurantURL,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.restaurant,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // Details Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: MySizes.xs,
                  horizontal: MySizes.sm,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.userName,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: MyColors.darkPrimaryTextColor,
                          ),
                    ),
                    const SizedBox(height: MySizes.xs),
                    Text(
                      "${restaurant.distance?.toStringAsFixed(1)} km",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: MySizes.xs),
                    Text(
                      restaurant.detailAddress ?? '',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
