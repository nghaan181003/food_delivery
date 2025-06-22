import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class AddressWidget extends StatelessWidget {
  final Rx<Order> currentOrder;
  final VoidCallback onUpdateAddress;

  const AddressWidget(
      {super.key, required this.currentOrder, required this.onUpdateAddress});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  'Lấy hàng: ${currentOrder.value.restaurantName}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              currentOrder.value.restAddress.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(color: MyColors.dividerColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  'Giao hàng: ${currentOrder.value.customerName}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: currentOrder.value.custStatus == "waiting"
                  ? onUpdateAddress
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      currentOrder.value.custAddress.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (currentOrder.value.custStatus == "waiting")
                    const Icon(Icons.arrow_forward_ios,
                        size: 20, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentOrder.value.customerName,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              currentOrder.value.custPhone,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ));
  }
}
