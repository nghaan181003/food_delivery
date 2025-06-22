import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/search/views/search_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const SearchScreen());
      },
      child: Padding(
          padding: const EdgeInsets.only(
              top: MySizes.md, left: MySizes.md, right: MySizes.md),
          child: SizedBox(
            height: 60,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: MySizes.sm),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: MyColors.secondaryTextColor,
                    ),
                    const SizedBox(width: MySizes.xs),
                    Text(
                      "Nhập tên món ăn",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: MyColors.secondaryTextColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
