import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_detail/order_detail_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

import '../../../../../shippers/home/models/order_model.dart';

class PreparingOrderTile extends StatelessWidget {
  final Order order;
  final VoidCallback? handleDone;

  const PreparingOrderTile({super.key, required this.order, this.handleDone});

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
          height: 135,
          child: Card(
            elevation: 4,
            shadowColor: MyColors.darkPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(MySizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        MyFormatter.formatCurrency(order.totalPrice!),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: handleDone,
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: MyColors.darkPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text("Đã xong",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(color: Colors.white)),
                          ),
                        ),
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
