import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';


class CategoryTile extends StatelessWidget {
  final Category category;
  final TextEditingController _controller = TextEditingController();

  final VoidCallback handleDelete;

  CategoryTile(
      {super.key, required this.category, required this.handleDelete}) {
    _controller.text = category.categoryName;
  }

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
            padding: const EdgeInsets.all(MySizes.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: MyColors.primaryTextColor),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    ),
                    onChanged: (value) {
                      category.categoryName = value;
                    },
                  ),
                ),
                IconButton(
                  onPressed: handleDelete,
                  icon: const Icon(Icons.clear_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
