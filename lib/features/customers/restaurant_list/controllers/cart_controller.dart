import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  var cartItems = <Item>[].obs;
  var itemQuantities = <String, int>{}.obs;
  int deliveryFee = 15000;

  int get totalItems {
    return itemQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  int get totalPrice {
    return cartItems.fold(0, (sum, item) {
      var quantity = itemQuantities[item.uniqueKey] ?? 1;
      return sum + (item.totalItemPrice.toInt() * quantity);
    });
  }

  int get orderPrice {
    OrderController.instance.order.totalPrice = totalPrice;
    return totalPrice + deliveryFee;
  }

  void addToCart(Item item) {
    final key = item.uniqueKey;
    final currentQty = itemQuantities[key] ?? 0;

    if (currentQty >= item.quantity) {
      Get.snackbar(
        "Thông báo",
        "Bạn đã thêm tối đa số lượng món còn lại.",
        backgroundColor: MyColors.primaryColor,
        colorText: MyColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (itemQuantities.containsKey(key)) {
      itemQuantities[key] = currentQty + 1;
    } else {
      cartItems.add(item);
      itemQuantities[key] = 1;
    }
  }

  void removeFromCart(Item item) {
    final key = item.uniqueKey;

    if (itemQuantities[item.uniqueKey] == 1) {
      cartItems.remove(item);
      itemQuantities.remove(key);
    } else {
      itemQuantities[key] = (itemQuantities[item.uniqueKey] ?? 0) - 1;
    }
  }

  void removeAllItem() {
    cartItems.clear();
    itemQuantities.clear();
  }
}
