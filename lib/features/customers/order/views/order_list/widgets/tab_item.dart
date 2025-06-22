import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int? count;

  const TabItem({
    super.key,
    required this.title,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        textAlign: TextAlign.center,
        title,
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .apply(color: MyColors.darkPrimaryTextColor),
      ),
    );
  }
}
