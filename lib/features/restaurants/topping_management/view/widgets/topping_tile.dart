import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ToppingTile extends StatelessWidget {
  const ToppingTile(
      {super.key, required this.topping, this.onTap, this.onChanged});

  final Rx<ToppingModel> topping;
  final VoidCallback? onTap;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            // Thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // * Tên
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        style: textStyle.bodySmall!
                            .apply(color: MyColors.primaryTextColor),
                        topping.value.name ?? "",
                      ),
                      const SizedBox(width: 2,),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                        color: MyColors.secondaryTextColor,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: MySizes.sm,
                  ),
                  // * Giá
                  Text(
                    style: textStyle.bodySmall!
                        .apply(color: MyColors.secondaryTextColor),
                    (topping.value.price ?? 0).formatCurrency,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: MySizes.sm,
            ),
            // Counter
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: topping.value.isActive ?? false, //TODO: gan value
                activeColor: MyColors.darkPrimaryColor,
                onChanged: onChanged,
              ),
            )
          ]),
          const SizedBox(height: MySizes.sm,),
          const Divider(
            thickness: 0.2,
            color: MyColors.dividerColor,
          ),
          
        ],
      ),
    );
  }
}
