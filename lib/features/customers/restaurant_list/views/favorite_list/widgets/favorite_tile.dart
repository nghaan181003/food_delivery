import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/favorite_list_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_item_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/menu_restaurant_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class FavoriteTile extends StatelessWidget {
  final TopItemModel item;

  const FavoriteTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(MenuRestaurantScreen(userId: item.partnerId));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: MySizes.sm),
        child: SizedBox(
          height: 110,
          child: Card(
            elevation: 2,
            shadowColor: MyColors.darkPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: MySizes.md,
                  right: MySizes.md,
                  left: MySizes.md,
                  bottom: MySizes.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(MySizes.borderRadiusMd),
                      child: CachedNetworkImage(
                        imageUrl: item.itemImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                  const SizedBox(
                    width: MySizes.md,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 190,
                        child: Text(
                          item.itemName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                      ),
                      const SizedBox(
                        height: MySizes.xs,
                      ),
                      SizedBox(
                        width: 190,
                        child: Text(
                          item.description,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                      ),
                      const SizedBox(
                        height: MySizes.xs,
                      ),
                      Text(
                        MyFormatter.formatCurrency(item.price.toInt()),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      )
                    ],
                  ),
                  const Spacer(),
                  LikeButton(
                    size: MySizes.iconMs,
                    animationDuration: const Duration(milliseconds: 500),
                    isLiked: FavoriteListController.instance.favoriteList
                        .any((fav) => fav.id == item.id),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_outline_outlined,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: MySizes.iconMd,
                      );
                    },
                    onTap: (isLiked) async {
                      final controller = FavoriteListController.instance;
                      if (isLiked) {
                        await controller.removeFromFavorites(item.id);
                      } else {
                        await controller.addToFavorites(item.id);
                      }
                      return !isLiked;
                    },
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
