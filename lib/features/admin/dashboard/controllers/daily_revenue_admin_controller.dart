import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/daily_revenue.dart';
import 'package:get/get.dart';

class DailyRevenueAdminController extends GetxController {
  final repository = OrderRepository();

  var revenueList = <DailyRevenueModel>[].obs;
  var isLoading = false.obs;

  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    ever(selectedDate, (date) {
      loadRevenue(date.month, date.year);
    });
    loadRevenue(selectedDate.value.month, selectedDate.value.year);
  }

  Future<void> loadRevenue(int month, int year) async {
  try {
    isLoading.value = true;
    final result = await repository.fetchDailyRevenueInAdmin(
      month,
      year,
    );

    final filledList = <DailyRevenueModel>[];
    final totalDays = DateUtils.getDaysInMonth(year, month);

    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(year, month, day);
      final existing = result.firstWhereOrNull((e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day);
      filledList.add(existing ?? DailyRevenueModel(date: date, revenue: 0));
    }

    revenueList.value = filledList;
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

