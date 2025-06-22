import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/rating/controllers/load_rating_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class RatingLoad extends StatelessWidget {
  final String orderId;

  const RatingLoad({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final loadingRatingController = Get.put(LoadRatingController());
    loadingRatingController.fetchOrderById(orderId);

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Đánh giá"),
      ),
      body: Obx(() {
        if (loadingRatingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = loadingRatingController.order.value;
        if (order == null) {
          return const Center(child: Text("Không tìm thấy đơn hàng."));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: MySizes.sm, vertical: MySizes.md),
          child: Column(
            children: [
              buildOrderInfoCard(context, order),
              const SizedBox(height: MySizes.sm),
              buildRatingCard(
                context,
                title: "Đánh giá đơn hàng",
                rating: order.custResRating ?? 0,
                comment: order.custResRatingComment ?? "",
              ),
              const SizedBox(height: MySizes.sm),
              buildRatingCard(
                context,
                title: "Đánh giá tài xế",
                rating: order.custShipperRating ?? 0,
                comment: order.custShipperRatingComment ?? "",
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildOrderInfoCard(BuildContext context, Order order) {
    return SizedBox(
      height: 105,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        shadowColor: MyColors.darkPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(MySizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đơn hàng #${order.id}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .apply(color: MyColors.darkPrimaryTextColor),
              ),
              const SizedBox(height: MySizes.sm),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: MyColors.openColor.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(MySizes.xs),
                      child: Text(
                        StatusHelper.custStatusTranslations[order.custStatus] ??
                            'Unknown status',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: MyColors.successColor),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(MyFormatter.formatTime(order.orderDatetime.toString())),
                  const SizedBox(width: MySizes.sm),
                  Text(MyFormatter.formatDate(order.orderDatetime.toString())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRatingCard(BuildContext context,
      {required String title,
      required double rating,
      required String comment}) {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        shadowColor: MyColors.darkPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(MySizes.md),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .apply(color: MyColors.primaryTextColor),
              ),
              const SizedBox(height: MySizes.sm),
              RatingStars(
                axis: Axis.horizontal,
                value: rating,
                onValueChanged: (v) {},
                starCount: 5,
                starSize: 24,
                maxValue: 5,
                starSpacing: 8,
                maxValueVisibility: true,
                valueLabelVisibility: false,
                starOffColor: MyColors.starOffColor,
                starColor: MyColors.starColor,
              ),
              const SizedBox(height: MySizes.md),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
                  border: Border.all(
                    color: MyColors.darkPrimaryColor,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(MySizes.md),
                child: Text(
                  comment,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
