import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/controllers/rating_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/views/rating_list/widgets/rating_tabbar.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/views/rating_list/widgets/rating_tile.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MenuRestaurantRating extends StatelessWidget {
  final String userId;
  const MenuRestaurantRating({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ratingController = Get.put(RatingController());
    ratingController.fetchRating(userId);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: const CustomAppBar(
            title: Text("Đánh giá"),
          ),
          body: Obx(() {
            if (ratingController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container(
              color: MyColors.primaryBackgroundColor,
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: MySizes.sm),
                        child: Container(
                          color: MyColors.greyWhite,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: MySizes.sm, bottom: MySizes.md, top: MySizes.sm, right: MySizes.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Obx(() => Text(
                                          MyFormatter.formatDouble(
                                              ratingController.value.value),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .apply(
                                                  color: MyColors.primaryTextColor),
                                        )),
                                    const SizedBox(
                                      height: MySizes.xs,
                                    ),
                                    Obx(() => RatingStars(
                                          axis: Axis.horizontal,
                                          value: ratingController.value.value,
                                          starCount: 5,
                                          starSize: 16,
                                          maxValue: 5,
                                          starSpacing: 8,
                                          maxValueVisibility: true,
                                          valueLabelVisibility: false,
                                          animationDuration:
                                              const Duration(milliseconds: 1000),
                                          starOffColor: MyColors.starOffColor,
                                          starColor: MyColors.starColor,
                                        )),
                                    const SizedBox(
                                        height: MySizes.spaceBtwItems / 2),
                                    Obx(() => Text(
                                        "${ratingController.count.value} đánh giá",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .apply(
                                                color:
                                                    MyColors.secondaryTextColor))),
                                  ],
                                ),
                                const SizedBox(
                                  width: MySizes.spaceBtwItems/2,
                                ),
                                
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LinearPercentIndicator(
                                      width: 160,
                                      lineHeight: 6,
                                      percent: ratingController.oneStarPercent,
                                      progressColor: Colors.amber,
                                      barRadius: const Radius.circular(3),
                                      backgroundColor:
                                          MyColors.starOffColor,
                                      leading: Row(
                                        children: [
                                          Text(
                                            "1",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .apply(
                                                    color: MyColors
                                                        .secondaryTextColor),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14)
                                        ],
                                      ),
                                      trailing: Text(
                                        "${MyFormatter.formatDouble(ratingController.oneStarPercent * 100)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .apply(
                                                color:
                                                    MyColors.secondaryTextColor),
                                      ),
                                    ),
                                    const SizedBox(height: 2,),
                                    LinearPercentIndicator(
                                      width: 160,
                                      lineHeight: 6,
                                      percent: ratingController.twoStarPercent,
                                      progressColor: Colors.amber,
                                      barRadius: const Radius.circular(3),
                                      backgroundColor:
                                          MyColors.starOffColor,
                                      leading: Row(
                                        children: [
                                          Text(
                                            "2",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .apply(
                                                    color: MyColors
                                                        .secondaryTextColor),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14)
                                        ],
                                      ),
                                      trailing: Text(
                                        "${MyFormatter.formatDouble(ratingController.twoStarPercent * 100)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .apply(
                                                color:
                                                    MyColors.secondaryTextColor),
                                      ),
                                    ),
                                    const SizedBox(height: 2,),
                                    LinearPercentIndicator(
                                      width: 160,
                                      lineHeight: 6,
                                      percent: ratingController.threeStarPercent,
                                      progressColor: Colors.amber,
                                      barRadius: const Radius.circular(3),
                                      backgroundColor:
                                          MyColors.starOffColor,
                                      leading: Row(
                                        children: [
                                          Text(
                                            "3",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .apply(
                                                    color: MyColors
                                                        .secondaryTextColor),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14)
                                        ],
                                      ),
                                      trailing: Text(
                                        "${MyFormatter.formatDouble(ratingController.threeStarPercent * 100)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .apply(
                                                color:
                                                    MyColors.secondaryTextColor),
                                      ),
                                    ),
                                    const SizedBox(height: 2,),
                                    LinearPercentIndicator(
                                      width: 160,
                                      lineHeight: 6,
                                      percent: ratingController.fourStarPercent,
                                      progressColor: Colors.amber,
                                      barRadius: const Radius.circular(3),
                                      backgroundColor:
                                          MyColors.starOffColor,
                                      leading: Row(
                                        children: [
                                          Text(
                                            "4",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .apply(
                                                    color: MyColors
                                                        .secondaryTextColor),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14)
                                        ],
                                      ),
                                      trailing: Text(
                                        "${MyFormatter.formatDouble(ratingController.fourStarPercent * 100)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .apply(
                                                color:
                                                    MyColors.secondaryTextColor),
                                      ),
                                    ),
                                    const SizedBox(height: 2,),
                                    LinearPercentIndicator(
                                      width: 160,
                                      lineHeight: 6,
                                      percent: ratingController.fiveStarPercent,
                                      progressColor: Colors.amber,
                                      barRadius: const Radius.circular(3),
                                      backgroundColor:
                                          MyColors.starOffColor,
                                      leading: Row(
                                        children: [
                                          Text(
                                            "5",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .apply(
                                                    color: MyColors
                                                        .secondaryTextColor),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14)
                                        ],
                                      ),
                                      trailing: Text(
                                        "${MyFormatter.formatDouble(ratingController.fiveStarPercent * 100)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .apply(
                                                color:
                                                    MyColors.secondaryTextColor),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems / 2),
                      RatingTabbar(
                        onTap: (index) {
                          ratingController
                              .updateFilter(index == 0 ? 0 : 6 - index);
                        },
                        tabs: const [
                          MyTab(value: 0, label: "Tất cả"),
                          MyTab(
                            value: 5,
                            label: "5",
                            icon: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          MyTab(
                              value: 4,
                              label: "4",
                              icon: Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                          MyTab(
                              value: 3,
                              label: "3",
                              icon: Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                          MyTab(
                              value: 2,
                              label: "2",
                              icon: Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                          MyTab(
                              value: 1,
                              label: "1",
                              icon: Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Obx(() {
                      if (ratingController.ratingList.isEmpty) {
                        return const Center(
                            child: Text("Không có đánh giá nào"));
                      }
                      final ratings = ratingController.filteredRatings;
                      if (ratings.isEmpty) {
                        return const Center(
                            child: Text("Không có đánh giá nào"));
                      }
                      return ListView.builder(
                        itemCount: ratings.length,
                        itemBuilder: (context, index) {
                          return RatingTile(rating: ratings[index]);
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
