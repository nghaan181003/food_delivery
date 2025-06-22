import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateRangeController extends GetxController {
  static DateRangeController get instance => Get.find();
  var dateRange =
      DateTimeRange(start: DateTime(DateTime.now().year), end: DateTime.now())
          .obs;
          
  Future<void> showRangeDatePicker() async {
    DateTimeRange? picked = await showDateRangePicker(
        fieldStartLabelText: "Lọc từ ngày",
        fieldEndLabelText: "Lọc đến ngày",
        context: Get.context!,
        firstDate: DateTime(
          DateTime.now().year - 20,
        ),
        lastDate: DateTime(
          DateTime.now().year + 20,
        ),
        initialDateRange: dateRange.value,
        initialEntryMode: DatePickerEntryMode.input);
    if (picked != null && picked != dateRange.value) {
      dateRange.value = picked;
    }
  }
}
