import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_detail/customer_order_detail.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class HistoryOrderTileCancelled extends StatelessWidget {
  final Order order;

  const HistoryOrderTileCancelled({super.key, required this.order});

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
        child: SizedBox(
          height: 165,
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
                      Text(
                        StatusHelper.custStatusTranslations[order.custStatus] ??
                            'Unknown status',
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
                    '#${order.id}',
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
                        MyFormatter.formatCurrency(order.totalPrice ?? 0),
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
