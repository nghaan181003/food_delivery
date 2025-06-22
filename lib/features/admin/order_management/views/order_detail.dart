import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/order_management/controllers/order_management_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class OrderDetail extends StatelessWidget {
  final String id;
  const OrderDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderManagementController>();

    final order = controller.order.value;

    return SizedBox(
        width: 400,
        child: order == null
            ? const Center(child: Text('Không có dữ liệu đơn hàng'))
            : Padding(
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.driverStatus == "reported" ||
                        order.driverStatus == "approved" ||
                        order.driverStatus == "rejected")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(MySizes.sm),
                            decoration: BoxDecoration(
                              color: MyColors.warningColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(MySizes.sm),
                            ),
                            child: Text(
                              "Đơn hàng đã được tài xế báo cáo",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.warningColor,
                                  ),
                            ),
                          ),
                          const SizedBox(height: MySizes.spaceBtwItems),
                          Text(
                            "Nội dung báo cáo: ${order.reason}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.secondaryTextColor,
                                ),
                          ),
                          const SizedBox(height: MySizes.spaceBtwItems),
                          if (order.driverStatus == "reported")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    controller.approveOrderReport(order.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColors.darkPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  child: const Text('Duyệt'),
                                ),
                                const SizedBox(width: MySizes.spaceBtwItems),
                                OutlinedButton(
                                  onPressed: () async {
                                    controller.rejectOrderReport(order.id);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: MyColors.errorColor),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  child: const Text(
                                    'Từ chối',
                                    style:
                                        TextStyle(color: MyColors.errorColor),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mã đơn hàng",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          order.id,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên khách hàng",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          order.customerName,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          order.custPhone,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Text(
                      "Địa chỉ khách hàng",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: MyColors.darkPrimaryTextColor,
                          ),
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Text(
                      order.custAddress ?? "Chưa có địa chỉ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: MyColors.secondaryTextColor,
                          ),
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên quán ăn",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          order.restaurantName,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Text(
                      "Địa chỉ quán ăn",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: MyColors.darkPrimaryTextColor,
                          ),
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Text(
                      order.restAddress ?? "Chưa có địa chỉ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: MyColors.secondaryTextColor,
                          ),
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên tài xế",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          (order.driverName == "Unknown")
                              ? "Chưa có tài xế"
                              : order.driverName!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          (order.driverName == "Unknown")
                              ? ""
                              : order.driverPhone!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Biển số xe",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          (order.driverName == "Unknown")
                              ? ""
                              : order.driverLicensePlate!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 190,
                              child: Text(
                                'Tên món',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.darkPrimaryTextColor,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: Text(
                                'SL',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.darkPrimaryTextColor,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Thành tiền',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.darkPrimaryTextColor,
                                    ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        ...order.orderItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 190,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.itemName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  MyColors.secondaryTextColor,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      if (item.toppings.isNotEmpty)
                                        ...item.toppings.map(
                                          (topping) => Padding(
                                            padding: const EdgeInsets.only(
                                                top: MySizes.sm,
                                                left: MySizes.sm),
                                            child: Text(
                                              "${topping.name} x ${((topping.price ?? 0).toInt()).formatCurrency}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .apply(
                                                      color: MyColors
                                                          .secondaryTextColor),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50, // Matches the header column width
                                  child: Text(
                                    '${item.quantity}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.secondaryTextColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    MyFormatter.formatCurrency(item.totalPrice),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.secondaryTextColor,
                                        ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng món ăn",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          MyFormatter.formatCurrency(order.getToTalPrice()),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phí vận chuyển",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          MyFormatter.formatCurrency(
                            order.deliveryFee ?? 0,
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng tiền",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                        ),
                        Text(
                          MyFormatter.formatCurrency(
                            (order.totalPrice ?? 0) + (order.deliveryFee ?? 0),
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Text(
                      "Ghi chú",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: MyColors.darkPrimaryTextColor,
                          ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Text(
                      order.note,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: MyColors.secondaryTextColor,
                          ),
                    ),
                  ],
                ),
              ));
  }
}
