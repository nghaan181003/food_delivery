import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/search/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class ApplyProductItem extends StatelessWidget {
  const ApplyProductItem(
      {super.key, required this.item, required this.value, this.onChanged});

  final Item item;
  final bool value;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                style: textStyle.bodySmall!
                    .apply(color: MyColors.primaryTextColor),
                item.itemName,
              ),
              Text(
                style: textStyle.bodySmall!
                    .apply(color: MyColors.secondaryTextColor),
                MyFormatter.formatCurrency(item.price),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
        ),
      ],
    );
  }
}
