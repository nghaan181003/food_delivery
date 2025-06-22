import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_detail/order_detail_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

import '../../../../../shippers/home/models/order_model.dart';

class HistoryOrderTile extends StatelessWidget {
  final Order order;

  const HistoryOrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      onTap: () => Get.to(OrderDetailScreen(selectedOrder: order)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: MySizes.md,
          right: MySizes.sm,
          left: MySizes.sm,
        ),
        child: SizedBox(
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
                        MyFormatter.formatDate(order.orderDatetime.toString()),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .apply(color: MyColors.primaryTextColor),
                      ),
                      Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: StatusHelper.getColor(
                          'restStatus', order.restStatus.toString()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      StatusHelper.getTranslation(
                          'restStatus', order.restStatus.toString()),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
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
                    order.id.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: MyColors.darkPrimaryTextColor),
                  ),
                  const SizedBox(
                    height: MySizes.xs,
                  ),
                  Row(
                    children: [
                      Text(
                        '${order.orderItems.fold(0, (sum, item) => sum + item.quantity)} món',
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
                          order.reason,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: MyColors.primaryTextColor),
                        ),
                      ),
                      Text(
                        MyFormatter.formatCurrency(order.totalPrice!),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.primaryTextColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
