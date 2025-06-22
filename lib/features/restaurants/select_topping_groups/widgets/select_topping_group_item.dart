import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class SelectToppingGroupItem extends StatelessWidget {
  const SelectToppingGroupItem(
      {super.key,
      required this.toppingGroup,
      required this.value,
      this.onChanged});

  final ToppingGroupModel toppingGroup;
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
                toppingGroup.name,
              ),
              Text(
                style: textStyle.bodySmall!
                    .apply(color: MyColors.secondaryTextColor),
                toppingGroup.toppingNames,
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
