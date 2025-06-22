import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class RatingTile extends StatelessWidget {
  final RatingModel rating;

  const RatingTile({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: MySizes.md,
        right: MySizes.sm,
        left: MySizes.sm,
      ),
      child: SizedBox(
        height: 155,
        child: Card(
          elevation: 4,
          shadowColor: MyColors.darkPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(MyImagePaths.iconImage),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(
                      width: MySizes.sm,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rating.customerName,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        const SizedBox(height: MySizes.xs),
                        RatingStars(
                          axis: Axis.horizontal,
                          value: rating.custResRating,
                          onValueChanged: (v) {},
                          starCount: 5,
                          starSize: 12,
                          maxValue: 5,
                          starSpacing: 4,
                          maxValueVisibility: true,
                          valueLabelVisibility: false,
                          valueLabelPadding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 8),
                          valueLabelMargin: const EdgeInsets.only(right: 8),
                          starOffColor: MyColors.starOffColor,
                          starColor: MyColors.starColor,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: MySizes.sm,
                ),
                Text(
                  rating.custResRatingComment,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: MyColors.primaryTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(
                  height: MySizes.sm,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MyFormatter.formatDate(rating.orderDatetime.toString()),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                    Text(
                      MyFormatter.formatTime(rating.orderDatetime.toString()),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .apply(color: MyColors.primaryTextColor),
                    )
                  ],
                )

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     InkWell(
                //       onTap: () => {},
                //       child: Container(
                //         width: 80,
                //         height: 30,
                //         decoration: BoxDecoration(
                //           color: MyColors.darkPrimaryColor,
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         child: Center(
                //           child: Text("Đã xong",
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .labelSmall!
                //                   .apply(color: Colors.white)),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
