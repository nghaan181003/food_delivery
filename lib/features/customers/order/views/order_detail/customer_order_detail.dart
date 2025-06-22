import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/chat/views/chat_customer.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/order_status_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class CustomerOrderDetail extends StatelessWidget {
  const CustomerOrderDetail({super.key, required this.selectedOrder});
  final Order selectedOrder;

  @override
  Widget build(BuildContext context) {
    final orderStatusController = Get.put(OrderStatusController());
    orderStatusController.orderStatus.value = selectedOrder.custStatus;
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
              bottom: MySizes.lg),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildInfoCard(
              context: context,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trạng thái đơn  -  ${(StatusHelper.custStatusTranslations[selectedOrder.custStatus])}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (selectedOrder.custStatus == 'cancelled')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lý do hủy: ",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: MyColors.errorColor,
                                    ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              selectedOrder.reason,
                              softWrap:
                                  true, // Ensures text wraps to the next line if it's too long
                              overflow: TextOverflow
                                  .ellipsis, // Adds "..." if the text is too long
                              maxLines:
                                  3, // Optional: Limits the number of lines
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: MyColors.primaryTextColor,
                                  ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.inventory_outlined,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.linear,
                                width: 55,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: orderStatusController
                                      .getContainerColor(1),
                                ),
                                child: LinearProgressIndicator(
                                  value: orderStatusController
                                      .container1Progress.value,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.primaryColor),
                                ),
                              )),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.local_dining,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.linear,
                                width: 55,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: orderStatusController
                                      .getContainerColor(2),
                                ),
                                child: LinearProgressIndicator(
                                  value: orderStatusController
                                      .container2Progress.value,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.primaryColor),
                                ),
                              )),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.delivery_dining,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.linear,
                                width: 55,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: orderStatusController
                                      .getContainerColor(3),
                                ),
                                child: LinearProgressIndicator(
                                  value: orderStatusController
                                      .container3Progress.value,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.primaryColor),
                                ),
                              )),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.home,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Trạng thái",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodySmall!
            //           .apply(color: MyColors.darkPrimaryTextColor),
            //     ),
            //     Text(
            //       StatusHelper
            //               .custStatusTranslations[selectedOrder.custStatus] ??
            //           'Unknown status',
            //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            //             color: MyColors.primaryTextColor,
            //             height: 2,
            //           ),
            //     )
            //   ],
            // ),
            const SizedBox(
              height: MySizes.spaceBtwItems,
            ),
            buildInfoCard(
              context: context,
              children: [
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: MyColors.primaryTextColor,
                            height: 2,
                          ),
                    )
                  ],
                ),
                const SizedBox(
                  height: MySizes.spaceBtwItems,
                ),
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
                    const Spacer(),
                    Text(
                      MyFormatter.formatTime(
                          selectedOrder.orderDatetime.toString()),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: MyColors.primaryTextColor,
                            height: 2,
                          ),
                    ),
                    const SizedBox(
                      width: MySizes.sm,
                    ),
                    Text(
                      MyFormatter.formatDateTime(selectedOrder.orderDatetime),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: MyColors.primaryTextColor,
                            height: 2,
                          ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: MySizes.spaceBtwItems),

            selectedOrder.driverName == "Unknown"
                ? buildInfoCard(
                    context: context,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Chưa có tài xế nhận đơn",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.secondaryTextColor),
                        ),
                      ),
                    ],
                  )
                : buildInfoCard(
                    context: context,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade200,
                            child: ClipOval(
                                child: Image.network(
                              selectedOrder.driverProfileUrl!,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person,
                                    size: 40, color: Colors.grey);
                              },
                            )),
                          ),
                          const SizedBox(
                            width: MySizes.sm,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${selectedOrder.driverName}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .apply(
                                        color: MyColors.darkPrimaryTextColor),
                              ),
                              const SizedBox(
                                height: MySizes.xs,
                              ),
                              Text(
                                "${selectedOrder.driverLicensePlate}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(color: MyColors.secondaryTextColor),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(
                                ChatCustomer(
                                  customerId: LoginController
                                      .instance.currentUser.userId,
                                  driverId: selectedOrder.assignedShipperId
                                      .toString(),
                                  currentUserId: LoginController
                                      .instance.currentUser.userId,
                                  driverName:
                                      selectedOrder.driverName.toString(),
                                  driverImage:
                                      selectedOrder.driverProfileUrl.toString(),
                                  orderId: selectedOrder.id,
                                  orderStatus: selectedOrder.custStatus,
                                ),
                              );
                            },
                            child: Image.asset(
                              MyImagePaths.iconChat,
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

            const SizedBox(height: MySizes.spaceBtwItems),
            buildInfoCard(
              context: context,
              children: [
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: MySizes.xs),
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.primaryColor)),
                    const SizedBox(
                      width: MySizes.sm,
                    ),
                    Text(
                      selectedOrder.restaurantName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.sm),
                Text(
                  selectedOrder.restAddress.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: MyColors.secondaryTextColor),
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4, right: MySizes.xs),
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.openColor,
                      ),
                    ),
                    const SizedBox(width: MySizes.xs),
                    Text(
                      "${selectedOrder.customerName} - ${selectedOrder.custPhone}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.sm),
                Text(
                  selectedOrder.custAddress.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: MyColors.secondaryTextColor),
                  maxLines: 5,
                ),
              ],
            ),

            const SizedBox(height: MySizes.spaceBtwItems),

            buildInfoCard(
              context: context,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: MySizes.sm),
                    Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            'Tên món',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 50, // Fixed width for the second column
                          child: Text(
                            'SL',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Thành tiền',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    ...selectedOrder.orderItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150, // Matches the header column width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .apply(
                                            color: MyColors.secondaryTextColor),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
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
                              width: 50, // Matches the header column width
                              child: Text(
                                '${item.quantity}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(color: MyColors.secondaryTextColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                MyFormatter.formatCurrency(item.totalPrice),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(color: MyColors.secondaryTextColor),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng món ăn",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        Text(
                          MyFormatter.formatCurrency(
                              selectedOrder.getToTalPrice()),
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
                          "Phí vận chuyển",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        Text(
                          MyFormatter.formatCurrency(
                            selectedOrder.deliveryFee ?? 0,
                          ),
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
                          "Tổng tiền",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        Text(
                          MyFormatter.formatCurrency(
                            (selectedOrder.totalPrice ?? 0) +
                                (selectedOrder.deliveryFee ?? 0),
                          ),
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
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildInfoCard(
      {required BuildContext context, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
