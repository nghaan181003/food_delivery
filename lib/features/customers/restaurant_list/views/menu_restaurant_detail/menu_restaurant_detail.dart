import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/price/price_widget.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/views/confirm_order_screen.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/favorite_list_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/rating_item_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/widgets/detail_cart.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/widgets/topping_sheet.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/views/rating_list/widgets/rating_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class MenuRestaurantDetail extends StatelessWidget {
  Item item;

  MenuRestaurantDetail({super.key, required this.item});
  final controller = Get.put(FavoriteListController());

  @override
  Widget build(BuildContext context) {
    //final partner = Get.arguments as DetailPartnerModel?;
    final cartController = Get.put(CartController());
    final restaurantController = Get.put(RestaurantController());
    final ratingItemController = Get.put(RatingItemController());
    ratingItemController.fetchRating(item.itemId);
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Chi tiết món ăn"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: item.itemImage,
              width: MediaQuery.of(context).size.width,
              height: 170,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(MySizes.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.itemName,
                            style: const TextStyle(
                              color: MyColors.primaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
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
                      const SizedBox(height: MySizes.sm),
                      Text(
                        item.description,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .apply(color: MyColors.secondaryTextColor),
                      ),
                      const SizedBox(height: MySizes.sm),
                      Row(
                        children: [
                          Text(
                            "Còn lại: ${item.quantity.toString()}",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(color: MyColors.secondaryTextColor),
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
                                .labelMedium!
                                .apply(color: MyColors.secondaryTextColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceWidget(
                            originalPrice: item.price,
                            salePrice: item.salePrice,
                          ),
                          Obx(() {
                            var quantity = cartController
                                    .itemQuantities[item.uniqueKey] ??
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
                      
                            if (restaurantController
                                    .detailPartner.value?.status ==
                                false) {
                              return const Icon(
                                Icons.add_box,
                                color: MyColors.secondaryTextColor,
                              );
                            } else {
                              return InkWell(
                                onTap: () async {
                                  final isShow = await restaurantController
                                      .getToppings(item.itemId);
                      
                                  if (isShow) {
                                    final result = await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (_) => ToppingSheet(
                                        toppings:
                                            restaurantController.toppings,
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
                              );
                            }
                          }),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: MySizes.sm,
                            left: MySizes.sm,
                            right: MySizes.sm),
                        child: Divider(color: MyColors.primaryBackgroundColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: MySizes.sm),
                        child: Text(
                          "Bình luận",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: MyColors.primaryTextColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              if (ratingItemController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final ratings = ratingItemController.ratingList;
              if (ratings.isEmpty) {
                return const Center(child: Text("Không có đánh giá nào"));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  return RatingTile(rating: ratings[index]);
                },
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (cartController.totalItems == 0) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            Get.bottomSheet(DetailCart());
          },
          child: Container(
            padding: const EdgeInsets.all(MySizes.md),
            decoration: BoxDecoration(
              color: MyColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 40,
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 26,
                      ),
                      Positioned(
                        top: 0,
                        left: 16,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: MyColors.darkPrimaryTextColor,
                          child: Text(
                            cartController.totalItems.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(color: MyColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  MyFormatter.formatCurrency(cartController.totalPrice),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
                const SizedBox(
                  width: MySizes.md,
                ),
                InkWell(
                  onTap: () {
                    Get.to(ConfirmOrderScreen());
                  },
                  child: Text(
                    "Đặt hàng",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(
                          color: MyColors.darkPrimaryTextColor,
                          fontWeightDelta: 2,
                        )
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
