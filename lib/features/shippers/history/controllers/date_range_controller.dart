import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateRangeHistoryController extends GetxController {
  static DateRangeHistoryController get instance => Get.find();

  var dateRange =
      DateTimeRange(start: DateTime(DateTime.now().year), end: DateTime.now())
          .obs;

  Future<void> showWeekPicker() async {
    DateTime selectedDate = await _showDatePicker();
    DateTime startOfWeek = _getStartOfWeek(selectedDate);
    DateTime endOfWeek = _getEndOfWeek(startOfWeek);

    dateRange.value = DateTimeRange(start: startOfWeek, end: endOfWeek);
    }

  Future<DateTime> _showDatePicker() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 20),
      lastDate: DateTime(DateTime.now().year + 20),
    );
    return picked ?? DateTime.now();
  }

  DateTime _getStartOfWeek(DateTime date) {
    int dayOfWeek = date.weekday;
    return date.subtract(Duration(days: dayOfWeek - 1));
  }

  DateTime _getEndOfWeek(DateTime startOfWeek) {
    return startOfWeek.add(const Duration(days: 6));
  }
}
