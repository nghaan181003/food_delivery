import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/price/price_widget.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/favorite_list_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_detail/menu_restaurant_detail.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/widgets/topping_sheet.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:like_button/like_button.dart';

class MenuRestaurantTile extends StatelessWidget {
  Item item;

  MenuRestaurantTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final restaurantController = Get.put(RestaurantController());
    final controller = Get.put(FavoriteListController());

    return InkWell(
      onTap: () {
        Get.to(MenuRestaurantDetail(item: item));
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: MySizes.sm, right: MySizes.sm, top: MySizes.xs, bottom: MySizes.sm),
        child: SizedBox(
          height: 135,
          child: Card(
            elevation: 4,
            shadowColor: MyColors.darkPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: MySizes.sm,
                  left: MySizes.md,
                  bottom: MySizes.sm,
                  right: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                    // child: CachedNetworkImage(
                    //   imageUrl: item.itemImage,
                    //   width: 55,
                    //   height: 55,
                    //   fit: BoxFit.cover,
                    //   placeholder: (context, url) =>
                    //       const Center(child: CircularProgressIndicator()),
                    //   errorWidget: (context, url, error) =>
                    //       const Icon(Icons.error),
                    // )),
                    child: ImageNetwork(
                      image: item.itemImage,
                      width: 55,
                      height: 55,
                      fitAndroidIos: BoxFit.cover,
                      onLoading:
                          const Center(child: CircularProgressIndicator()),
                      onError: const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    width: MySizes.spaceBtwItems,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                item.itemName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(color: MyColors.primaryTextColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Obx(() => LikeButton(
                                  size: MySizes.iconMs,
                                  animationDuration:
                                      const Duration(milliseconds: 500),
                                  isLiked: controller.favoriteList
                                      .any((fav) => fav.id == item.itemId),
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
                                    if (isLiked) {
                                      await controller
                                          .removeFromFavorites(item.itemId);
                                    } else {
                                      await controller
                                          .addToFavorites(item.itemId);
                                    }
                                    return !isLiked;
                                  },
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: MySizes.xs,
                        ),
                        Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(color: MyColors.secondaryTextColor),
                        ),
                        const SizedBox(
                          height: MySizes.xs,
                        ),
                        Row(
                          children: [
                            Text(
                              "Còn lại: ${item.quantity.toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .apply(color: MyColors.primaryTextColor),
                            ),
                            const SizedBox(
                              width: MySizes.sm,
                            ),
                            Container(
                                color: MyColors.dividerColor,
                                width: 0.8,
                                height: 15),
                            const SizedBox(
                              width: MySizes.sm,
                            ),
                            Text(
                              "Đã bán: ${item.sales.toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .apply(color: MyColors.primaryTextColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: MySizes.xs,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PriceWidget(
                              originalPrice: item.price,
                              salePrice: item.salePrice,
                            ),
                            Obx(() {
                              var quantity =
                                  cartController.itemQuantities[item.itemId] ??
                                      0;

                              if (item.quantity == 0) {
                                return Text(
                                  "Đã hết món",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(color: MyColors.primaryColor),
                                );
                              }

                              return AnimatedSwitcher(
                                // animation quay 180 do
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return RotationTransition(
                                    turns: Tween<double>(begin: 0.5, end: 1.0)
                                        .animate(animation),
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: restaurantController
                                            .detailPartner.value?.status ==
                                        false
                                    ? const Icon(
                                        Icons.add_box,
                                        key: ValueKey("closed"),
                                        color: MyColors.secondaryTextColor,
                                      )
                                    : InkWell(
                                        key: const ValueKey("icon"),
                                        onTap: () async {
                                          final isShow =
                                              await restaurantController
                                                  .getToppings(item.itemId);

                                          if (isShow) {
                                            final result =
                                                await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              builder: (_) => ToppingSheet(
                                                toppings: restaurantController
                                                    .toppings,
                                              ),
                                            );

                                            if (result is List<ToppingModel>) {
                                              item = item.copyWith(
                                                  selectedToppings: result);
                                            }
                                          }
                                          if (quantity < item.quantity) {
                                            cartController.addToCart(item);
                                          }
                                        },
                                        child: const Icon(
                                          Icons.add_box,
                                          color: MyColors.darkPrimaryTextColor,
                                        ),
                                      ),
                              );
                            }),
                          ],
                        ),
                      ],
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
