import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import '../../../../shippers/home/models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.selectedOrder});
  final Order selectedOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Chi tiết đơn hàng"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: MySizes.sm,
            right: MySizes.sm,
            top: MySizes.md,
            bottom: MySizes.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(MySizes.md),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trạng thái",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: StatusHelper.getColor('restStatus',
                                  selectedOrder.restStatus.toString()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              StatusHelper.getTranslation('restStatus',
                                  selectedOrder.restStatus.toString()),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mã đơn hàng",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Text(
                            "#${selectedOrder.id.toString()}",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Thời gian đặt hàng",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Text(
                            "${MyFormatter.formatTime(selectedOrder.orderDatetime.toString())} ${MyFormatter.formatDateTime(selectedOrder.orderDatetime)}",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(MySizes.md),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tên khách hàng",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Text(
                            selectedOrder.customerName,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Số điện thoại",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Text(
                            selectedOrder.custPhone,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(MySizes.md),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tên tài xế",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Text(
                            selectedOrder.driverName.toString(),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Số điện thoại",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Text(
                            selectedOrder.driverPhone.toString(),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(MySizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 150,
                              child: Text('Tên món',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          color: MyColors.darkPrimaryTextColor),
                                  overflow: TextOverflow.ellipsis)),
                          SizedBox(
                              width: 50,
                              child: Text('SL',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          color: MyColors.darkPrimaryTextColor),
                                  textAlign: TextAlign.center)),
                          Expanded(
                              child: Text('Thành tiền',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          color: MyColors.darkPrimaryTextColor),
                                  textAlign: TextAlign.end)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...selectedOrder.orderItems.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.itemName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color:
                                                    MyColors.primaryTextColor,
                                                height: 2,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2),
                                      if (item.toppings.isNotEmpty)
                                        ...item.toppings.map(
                                          (topping) => Text(
                                            "${topping.name} x ${((topping.price ?? 0).toInt()).formatCurrency}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .apply(
                                                    color: MyColors
                                                        .secondaryTextColor),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: 50,
                                    child: Text('${item.quantity}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: MyColors.primaryTextColor,
                                              height: 2,
                                            ),
                                        textAlign: TextAlign.center)),
                                Expanded(
                                    child: Text(
                                        MyFormatter.formatCurrency(
                                            item.totalPrice),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: MyColors.primaryTextColor,
                                              height: 2,
                                            ),
                                        textAlign: TextAlign.end)),
                              ],
                            ),
                          )),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      const Divider(color: MyColors.dividerColor),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tổng tiền",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Text(
                            MyFormatter.formatCurrency(
                                selectedOrder.totalPrice!),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Text(
                        "Ghi chú",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Text(
                        selectedOrder.note,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
