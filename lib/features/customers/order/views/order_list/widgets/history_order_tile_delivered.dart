import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_detail/customer_order_detail.dart';
import 'package:food_delivery_h2d/features/customers/rating/views/rating_load.dart';
import 'package:food_delivery_h2d/features/customers/rating/views/rating_view.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class HistoryOrderTileDelivered extends StatelessWidget {
  final Order order;

  const HistoryOrderTileDelivered({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(CustomerOrderDetail(
          selectedOrder: order,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: MySizes.md,
          right: MySizes.sm,
          left: MySizes.sm,
        ),
        child: Card(
          elevation: 4,
          shadowColor: MyColors.darkPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${order.id}',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                    Text(
                      MyFormatter.formatDate(order.orderDatetime.toString()),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: MySizes.xs,
                ),
                const Divider(
                  color: MyColors.dividerColor,
                ),
                const SizedBox(
                  height: MySizes.xs,
                ),
                Text(
                  order.restaurantName,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
                const SizedBox(
                  height: MySizes.sm,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.orderItems.fold(0, (sum, item) => sum + item.quantity)} món',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                    Text(
                      MyFormatter.formatCurrency(
                          order.totalPrice! + order.deliveryFee!),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
                const Divider(
                  color: MyColors.dividerColor,
                ),
                const SizedBox(
                  height: MySizes.xs,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        StatusHelper
                                .custStatusTranslations[order.custStatus] ??
                            'Unknown status',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: MyColors.primaryTextColor),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        order.custResRating == null ||
                                order.custShipperRating == null
                            ? Get.to(RatingView(order: order))
                            : Get.to(RatingLoad(orderId: order.id));
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          color: order.custResRating == null ||
                                  order.custShipperRating == null
                              ? MyColors.darkPrimaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            order.custResRating == null ||
                                    order.custShipperRating == null
                                ? "Đánh giá"
                                : "Đã đánh giá",
                            style:
                                Theme.of(context).textTheme.labelSmall!.apply(
                                      color: order.custResRating == null ||
                                              order.custShipperRating == null
                                          ? Colors.white
                                          : MyColors.darkPrimaryColor,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
