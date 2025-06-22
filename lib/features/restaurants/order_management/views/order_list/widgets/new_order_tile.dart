import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_detail/order_detail_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

import '../../../../../shippers/home/models/order_model.dart';

class NewOrderTile extends StatelessWidget {
  final Order order;

  final VoidCallback? handleAccept;
  final VoidCallback? handleCancel;

  const NewOrderTile(
      {super.key, required this.order, this.handleAccept, this.handleCancel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(OrderDetailScreen(selectedOrder: order)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: MySizes.md,
          right: MySizes.sm,
          left: MySizes.sm,
        ),
        child: SizedBox(
          //height: 180,
          height: (order.orderItems.length == 1) ? 157 : 200,
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
                        order.id.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      Text(
                        MyFormatter.formatTime(order.orderDatetime.toString()),
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
                  Row(
                    children: [
                      Text(
                        order.customerName,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.primaryTextColor),
                      ),
                      const SizedBox(
                        width: MySizes.sm,
                      ),
                      const SizedBox(
                        height: 12,
                        child: VerticalDivider(
                          color: MyColors.dividerColor,
                          width: 12,
                        ),
                      ),
                      const SizedBox(
                        width: MySizes.sm,
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
                  Expanded(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: order.orderItems.length > 2
                              ? 2
                              : order.orderItems.length,
                          itemBuilder: (context, index) {
                            final item = order.orderItems[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '${item.quantity} x ${item.itemName} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(color: MyColors.primaryTextColor),
                              ),
                            );
                          },
                        ),
                        if (order.orderItems.length > 2)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '...',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .apply(color: MyColors.primaryTextColor),
                            ),
                          ),
                      ],
                    ),
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
                        onTap: handleCancel,
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: MyColors.darkPrimaryColor, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text("Từ chối",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(color: MyColors.darkPrimaryColor)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: MySizes.sm,
                      ),
                      InkWell(
                        onTap: handleAccept,
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: MyColors.darkPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text("Xác nhận",
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
