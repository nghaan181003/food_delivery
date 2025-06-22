import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class InvoiceWidget extends StatelessWidget {
  final Rx<Order> order; // Change to Rx<Order> to make it reactive

  const InvoiceWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hóa đơn quán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tổng hóa đơn', style: TextStyle(fontSize: 14)),
                  Text(
                    MyFormatter.formatCurrency(order.value.totalPrice ?? 0),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text('Phí vận chuyển', style: TextStyle(fontSize: 14)),
              //     Text(
              //       MyFormatter.formatCurrency(order.value.deliveryFee ?? 0),
              //       style: const TextStyle(fontSize: 14),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quán giảm giá', style: TextStyle(fontSize: 14)),
                  Text('0 VND', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: MyColors.dividerColor, thickness: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng tiền thanh toán',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    MyFormatter.formatCurrency(
                      (order.value.totalPrice ?? 0) +
                          (order.value.deliveryFee ?? 0),
                    ),
                    style: const TextStyle(
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
