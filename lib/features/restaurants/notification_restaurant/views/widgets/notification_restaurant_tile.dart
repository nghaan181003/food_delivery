import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class NotificationRestaurantTile extends StatelessWidget {
  const NotificationRestaurantTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: MySizes.sm, right: MySizes.sm, left: MySizes.sm),
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
              child: Column(
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "20/12/2024",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                    Text(
                      "12:00",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
                ],
              ),
            ),
          ),
        )
        );
      
    
  }
}
