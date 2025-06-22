import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/menu_restaurant_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class ItemHomeSearchTile extends StatelessWidget {
  final Item item;

  const ItemHomeSearchTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(MenuRestaurantScreen(
          userId: item.partnerId,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: MySizes.sm, right: MySizes.sm, top: MySizes.sm),
        child: SizedBox(
          height: 90,
          child: Card(
            elevation: 4,
            shadowColor: MyColors.darkPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: MySizes.sm,
                  left: MySizes.md,
                  bottom: MySizes.sm,
                  right: MySizes.sm),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(MySizes.borderRadiusMd),
                      child: CachedNetworkImage(
                        imageUrl: item.itemImage,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                  const SizedBox(
                    width: MySizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.itemName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      const SizedBox(
                        height: MySizes.sm,
                      ),
                      Text(
                        MyFormatter.formatCurrency(item.price),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .apply(color: MyColors.primaryTextColor),
                      ),
                    ],
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
