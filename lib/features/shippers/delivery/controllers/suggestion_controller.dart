import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/driver/driver_repository.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:get/get.dart';

class SuggestionController extends GetxController {
  static SuggestionController get instance => Get.find();

  var suggestedOrder = <Order>[].obs;

  var mergeOrders = <Order>[].obs;

  final _driverRepository = DriverRepository();
  final _orderRepository = OrderRepository();

  String get driverId => LoginController.instance.currentUser.driverId;

  Future<void> getSuggestionOrder() async {
    final res = await _driverRepository.getSuggestionOrderForDriver(
        LoginController.instance.currentUser.driverId);

    if (res.status == Status.ERROR) {
      return;
    }

    suggestedOrder.assignAll(res.data ?? []);
  }

  void addSuggestionOrder(Order order) {
    suggestedOrder.add(order);
  }

  void removeSugesstionOrder(String id) {
    suggestedOrder.removeWhere((order) => order.id == id);
  }

  Future<void> rejectSuggestionOrder(String orderId) async {
    final res = await _orderRepository.rejectSuggestionOrder(
        orderId: orderId, driverId: driverId);

    if (res.status == Status.ERROR) {
      return;
    }
    removeSugesstionOrder(orderId);
  }

  Future<void> acceptSuggestionOrder(Order order) async {
    final res = await _orderRepository.acceptSuggestionOrder(
        orderId: order.id, driverId: driverId);

    if (res.status == Status.ERROR) {
      return;
    }
    removeSugesstionOrder(order.id);

    mergeOrders.add(order);
  }

  bool get isEmpty => suggestedOrder.isEmpty;
}
