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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: MyColors.darkPrimaryTextColor),
          ),
          // if (count != null && count! > 0) 
          //   Container(
          //     margin: const EdgeInsets.only(left: 4.0),
          //     padding: const EdgeInsets.all(4.0), 
          //     decoration: const BoxDecoration(
          //       color: MyColors.darkPrimaryTextColor, 
          //       shape: BoxShape.circle, 
          //     ),
          //     child: Text(
          //       count! > 9 ? '9+' : count.toString(), 
          //       style: const TextStyle(
          //         color: Colors.white, 
          //         fontSize: 12, 
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
