import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class ArrangeCategoryTile extends StatelessWidget {
  final Category category;

  const ArrangeCategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: MySizes.sm, right: MySizes.sm, left: MySizes.sm),
      child: SizedBox(
        height: 70,
        child: Card(
          elevation: 4,
          shadowColor: MyColors.darkPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.categoryName,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: MyColors.primaryTextColor),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.import_export_rounded, color: MyColors.secondaryTextColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
