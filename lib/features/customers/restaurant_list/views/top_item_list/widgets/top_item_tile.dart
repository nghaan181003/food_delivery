import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_item_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/menu_restaurant_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class TopItemTile extends StatelessWidget {
  final TopItemModel item;

  const TopItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(MenuRestaurantScreen(userId: item.partnerId));
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                        child: CachedNetworkImage(
                          imageUrl: item.itemImage,
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
                        item.itemName,
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
                  SizedBox(
                    width: 80,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Đã bán: ${item.sales}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
