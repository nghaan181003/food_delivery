import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverDateRangeController extends GetxController {
  Rx<DateTimeRange> dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, 1, 1),
    end: DateTime.now(),
  ).obs;

  void updateDateRange(DateTimeRange newRange) {
    dateRange.value = newRange;
  }
  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? newRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange: dateRange.value,
    );

    if (newRange != null) {
      updateDateRange(newRange);
    }
  }
  
}
