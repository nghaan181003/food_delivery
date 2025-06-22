import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/views/rating_list/widgets/rating_tabbar.dart';
import 'package:food_delivery_h2d/features/shippers/rating/controllers/driver_rating_controller.dart';
import 'package:food_delivery_h2d/features/shippers/rating/views/driver_rating_tile.dart';
import 'package:food_delivery_h2d/features/shippers/rating/views/widgets/driver_rating_tabbar.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DriverRating extends StatelessWidget {
  const DriverRating({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverRatingController());
    controller.fetchRating(LoginController.instance.currentUser.driverId);
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text("Đánh giá của tôi"),
        ),
        body: SingleChildScrollView(child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Container(
              color: MyColors.primaryBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: MySizes.sm),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: MySizes.sm),
                          child: Container(
                            color: MyColors.greyWhite,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: MySizes.sm,
                                  bottom: MySizes.md,
                                  top: MySizes.sm,
                                  right: MySizes.sm),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Obx(() => Text(
                                            MyFormatter.formatDouble(controller.value.value),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .apply(
                                                    color: MyColors
                                                        .primaryTextColor),
                                          )),
                                      const SizedBox(
                                        height: MySizes.xs,
                                      ),
                                      Obx(() => RatingStars(
                                            axis: Axis.horizontal,
                                            value: controller.value.value,
                                            onValueChanged: (v) {},
                                            starCount: 5,
                                            starSize: 16,
                                            maxValue: 5,
                                            starSpacing: 8,
                                            maxValueVisibility: true,
                                            valueLabelVisibility: false,
                                            animationDuration: const Duration(
                                                milliseconds: 1000),
                                            starOffColor: MyColors.starOffColor,
                                            starColor: MyColors.starColor,
                                          )),
                                      const SizedBox(
                                          height: MySizes.spaceBtwItems / 2),
                                      Obx(() => Text(
                                            "${controller.count.value} đánh giá",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .apply(
                                                    color: MyColors
                                                        .primaryTextColor),
                                          )),
                                      const SizedBox(
                                          height: MySizes.spaceBtwItems / 2),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: MySizes.spaceBtwItems / 2,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      LinearPercentIndicator(
                                        width: 160,
                                        lineHeight: 6,
                                        percent: controller.oneStarPercent,
                                        progressColor: Colors.amber,
                                        barRadius: const Radius.circular(3),
                                        backgroundColor: MyColors.starOffColor,
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
                                          "${MyFormatter.formatDouble(controller.oneStarPercent * 100)}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: MyColors
                                                      .secondaryTextColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      LinearPercentIndicator(
                                        width: 160,
                                        lineHeight: 6,
                                        percent: controller.twoStarPercent,
                                        progressColor: Colors.amber,
                                        barRadius: const Radius.circular(3),
                                        backgroundColor: MyColors.starOffColor,
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
                                          "${MyFormatter.formatDouble(controller.twoStarPercent * 100)}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: MyColors
                                                      .secondaryTextColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      LinearPercentIndicator(
                                        width: 160,
                                        lineHeight: 6,
                                        percent: controller.threeStarPercent,
                                        progressColor: Colors.amber,
                                        barRadius: const Radius.circular(3),
                                        backgroundColor: MyColors.starOffColor,
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
                                          "${MyFormatter.formatDouble(controller.threeStarPercent * 100)}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: MyColors
                                                      .secondaryTextColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      LinearPercentIndicator(
                                        width: 160,
                                        lineHeight: 6,
                                        percent: controller.fourStarPercent,
                                        progressColor: Colors.amber,
                                        barRadius: const Radius.circular(3),
                                        backgroundColor: MyColors.starOffColor,
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
                                          "${MyFormatter.formatDouble(controller.fourStarPercent * 100)}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: MyColors
                                                      .secondaryTextColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      LinearPercentIndicator(
                                        width: 160,
                                        lineHeight: 6,
                                        percent: controller.fiveStarPercent,
                                        progressColor: Colors.amber,
                                        barRadius: const Radius.circular(3),
                                        backgroundColor: MyColors.starOffColor,
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
                                          "${MyFormatter.formatDouble(controller.fiveStarPercent * 100)}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: MyColors
                                                      .secondaryTextColor),
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
                      DriverRatingTabbar(
                        onTap: (index) {
                          controller
                              .updateFilter(index == 0 ? 0 : 6 - index);
                        },
                        tabs: const [
                          DriverTabbar(value: 0, label: "Tất cả"),
                          DriverTabbar(
                            value: 5,
                            label: "5",
                            icon: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          DriverTabbar(
                              value: 4,
                              label: "4",
                              icon: Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                          DriverTabbar(
                              value: 3,
                              label: "3",
                              icon: Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                          DriverTabbar(
                              value: 2,
                              label: "2",
                              icon: Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                          DriverTabbar(
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
                  ),
                  Obx(() {
                    if (controller.ratingList.isEmpty) {
                      return const Center(child: Text("Không có đánh giá nào"));
                    }
                    final ratings = controller.filteredRatings;
                    if (ratings.isEmpty) {
                      return const Center(child: Text("Không có đánh giá nào"));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ratings.length,
                      itemBuilder: (context, index) {
                        return DriverRatingTile(rating: ratings[index]);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        })),
      ),
    );
  }
}
