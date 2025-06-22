import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/widgets/cart_item_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class DetailCart extends StatelessWidget {
  final cartController = CartController.instance;
  DetailCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      top: MySizes.md, bottom: MySizes.sm, left: MySizes.md),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Giỏ hàng",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 5,
                        child: InkWell(
                          onTap: () {
                            cartController.removeAllItem();
                          },
                          child: const Text(
                            "Xóa tất cả",
                            style: TextStyle(
                                fontSize: 12,
                                color: MyColors.darkPrimaryTextColor),
                          ),
                        ),
                      ),
                    ],
                  )),
              Obx(() {
                return Column(
                  children: cartController.cartItems.map((item) {
                    var quantity =
                        cartController.itemQuantities[item.uniqueKey] ?? 1;
                    return CartItemTile(
                      item: item,
                      quantity: quantity,
                      onRemove: () {
                        cartController.removeFromCart(item);
                      },
                      onAdd: () {
                        cartController.addToCart(item);
                      },
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
