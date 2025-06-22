import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/follow_order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class OrderDetailsWidget extends StatelessWidget {
  final Rx<Order> currentOrder;

  const OrderDetailsWidget({super.key, required this.currentOrder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chi tiết đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mã đơn hàng:', style: TextStyle(fontSize: 14)),
            Text('#${currentOrder.value.id}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Số lượng món:',
                style:
                    TextStyle(fontSize: 14, color: MyColors.primaryTextColor)),
            Text('${currentOrder.value.orderItems.length}',
                style: const TextStyle(
                    fontSize: 14, color: MyColors.primaryTextColor)),
          ],
        ),
        const Divider(color: MyColors.dividerColor, thickness: 1),
        const SizedBox(height: 8),
        const Row(
          children: [
            SizedBox(
                width: 150,
                child: Text('Tên món',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis)),
            SizedBox(
                width: 50,
                child: Text('SL',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center)),
            Expanded(
                child: Text('Thành tiền',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end)),
          ],
        ),
        const SizedBox(height: 8),
        ...currentOrder.value.orderItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.itemName,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                        if (item.toppings.isNotEmpty)
                          ...item.toppings.map(
                            (topping) => Text(
                              "${topping.name} x ${((topping.price ?? 0).toInt()).formatCurrency}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .apply(color: MyColors.secondaryTextColor),
                            ),
                          )
                      ],
                    ),
                  ),
                  SizedBox(
                      width: 50,
                      child: Text('${item.quantity}',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center)),
                  Expanded(
                      child: Text(MyFormatter.formatCurrency(item.totalPrice),
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.end)),
                ],
              ),
            )),
        const Divider(color: MyColors.dividerColor, thickness: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng:', style: TextStyle(fontSize: 14)),
            Text(MyFormatter.formatCurrency(currentOrder.value.totalPrice ?? 0),
                style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => FollowOrderController.instance.isLoading.value
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phí vận chuyển:', style: TextStyle(fontSize: 14)),
                  SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Phí vận chuyển:', style: TextStyle(fontSize: 14)),
                  Text(
                      MyFormatter.formatCurrency(
                          currentOrder.value.deliveryFee ?? 0),
                      style: const TextStyle(fontSize: 14)),
                ],
              )),
        const SizedBox(height: 8),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng tiền:',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryTextColor)),
                Text(
                    MyFormatter.formatCurrency(
                        (currentOrder.value.totalPrice ?? 0) +
                            (currentOrder.value.deliveryFee ?? 0)),
                    style: const TextStyle(
                        fontSize: 14,
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.bold)),
              ],
            )),
        Obx(() => currentOrder.value.paymentStatus == "paid"
            ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                if (currentOrder.value.paymentMethod == "Cash")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset('assets/icons/cash.png',
                          width: 80, height: 80),
                      const Text("Đã thanh toán bằng Tiền mặt",
                          style: TextStyle(
                              fontSize: 16,
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset('assets/icons/ic_paid.png',
                          width: 80, height: 80),
                      Text(
                          "Đã thanh toán bằng ${currentOrder.value.paymentMethod}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
              ])
            : const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Chưa thanh toán",
                      style: TextStyle(
                          fontSize: 16,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              )),
      ],
    );
  }
}
