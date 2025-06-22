import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({super.key, required this.originalPrice, this.salePrice});

  final int originalPrice;
  final int? salePrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          MyFormatter.formatCurrency(originalPrice),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                decoration: salePrice != null
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: salePrice != null
                    ? MyColors.primaryTextColor
                    : MyColors.darkPrimaryTextColor,
              ),
        ),
        if (salePrice != null)
          Row(
            children: [
              const SizedBox(
                width: 4,
              ),
              Text(
                MyFormatter.formatCurrency(salePrice!),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(color: MyColors.darkPrimaryTextColor),
              ),
            ],
          ),
      ],
    );
  }
}
