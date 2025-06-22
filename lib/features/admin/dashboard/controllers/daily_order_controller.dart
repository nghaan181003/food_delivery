import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/models/daily_order_model.dart';
import 'package:get/get.dart';

class DailyOrderController extends GetxController {
  final repository = OrderRepository();

  var orderList = <DailyOrderModel>[].obs;
  var isLoading = false.obs;

  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    ever(selectedDate, (date) {
      loadOrder(date.month, date.year);
    });
    loadOrder(selectedDate.value.month, selectedDate.value.year);
  }

  Future<void> loadOrder(int month, int year) async {
  try {
    isLoading.value = true;
    final result = await repository.fetchDailyOrderInAdmin(
      month,
      year,
    );

    final filledList = <DailyOrderModel>[];
    final totalDays = DateUtils.getDaysInMonth(year, month);

    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(year, month, day);
      final existing = result.firstWhereOrNull((e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day);
      filledList.add(existing ?? DailyOrderModel(date: date, total: 0, delivering: 0, delivered: 0, cancelled: 0));
    }

    orderList.value = filledList;
  } catch (e) {
    print(e);
  } finally {
    isLoading.value = false;
  }
}


  void pickNewDate(DateTime newDate) {
    selectedDate.value = newDate;
  }
}

