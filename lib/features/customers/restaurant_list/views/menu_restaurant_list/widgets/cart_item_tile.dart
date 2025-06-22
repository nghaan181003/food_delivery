import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class CartItemTile extends StatelessWidget {
  final Item item;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const CartItemTile(
      {super.key,
      required this.item,
      required this.quantity,
      required this.onRemove,
      required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MySizes.md, right: MySizes.xs),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: MySizes.md, right: MySizes.md),
            child: Divider(color: MyColors.primaryBackgroundColor),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: MySizes.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                  child: CachedNetworkImage(
                    imageUrl: item.itemImage,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(
                  width: MySizes.spaceBtwItems,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        item.itemName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: MyColors.primaryTextColor),
                      ),
                    ),
                    const SizedBox(
                      height: MySizes.xs,
                    ),
                    Text(
                      MyFormatter.formatCurrency(item.salePrice ?? item.price),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(
                      height: MySizes.xs,
                    ),
                    ...item.selectedToppings.map(
                      (topping) => SizedBox(
                        width: 150,
                        child: Text(
                          "${topping.name} x ${((topping.price ?? 0).toInt()).formatCurrency}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: MyColors.secondaryTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.remove_circle_outline_rounded,
                          color: MyColors.darkPrimaryTextColor),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_circle,
                          color: MyColors.darkPrimaryTextColor),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
