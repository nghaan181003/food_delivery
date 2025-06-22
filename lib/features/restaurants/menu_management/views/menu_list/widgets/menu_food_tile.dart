import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_delivery_h2d/common/widgets/price/price_widget.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/update_menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_food_detail/menu_food_detail.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class MenuFoodTile extends StatelessWidget {
  final Item item;

  const MenuFoodTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final menuFoodController = Get.put(MenuFoodController());
    final updateMenuFoodController = Get.put(UpdateMenuFoodController());

    return InkWell(
      onTap: () {
        updateMenuFoodController.isEditting.value = true;
        Get.to(() => MenuFoodDetailScreen(selectedItem: item));
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: MySizes.sm, right: MySizes.sm, left: MySizes.sm),
        child: Slidable(
          endActionPane: ActionPane(motion: const DrawerMotion(), children: [
            SlidableAction(
              onPressed: ((context) {
                updateMenuFoodController.isEditting.value = true;
                Get.to(() => MenuFoodDetailScreen(selectedItem: item));
              }),
              backgroundColor: MyColors.primaryTextColor,
              icon: Icons.edit,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(MySizes.cardRadiusMd),
                  bottomLeft: Radius.circular(MySizes.cardRadiusMd)),
            ),
            SlidableAction(
              onPressed: ((context) {
                updateMenuFoodController.removeItem(item.itemId);
              }),
              backgroundColor: MyColors.errorColor,
              icon: Icons.delete,
              padding: const EdgeInsets.all(MySizes.md),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(MySizes.cardRadiusMd),
                  bottomRight: Radius.circular(MySizes.cardRadiusMd)),
            ),
          ]),
          child: SizedBox(
            height: 90,
            // decoration: BoxDecoration(
            //   border: Border.all(color: MyColors.secondaryTextColor, width: 0.5),
            //   borderRadius: BorderRadius.circular(12),
            // ),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.itemName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: MyColors.darkPrimaryTextColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: MySizes.sm,
                          ),
                          PriceWidget(
                            originalPrice: item.price,
                            salePrice: item.salePrice,
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: item.isAvailable.value,
                            activeColor: MyColors.darkPrimaryColor,
                            onChanged: (bool value) {
                              menuFoodController.toggleItemAvailability(item);
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
