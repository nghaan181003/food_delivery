import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/income/controllers/date_range_controller.dart';
import 'package:food_delivery_h2d/features/shippers/income/controllers/income_controller.dart';
import 'package:get/get.dart';

class DriverFilterWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const DriverFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRangeOverTimeController = Get.put(DriverDateRangeController());
    final statisticController = Get.put(IncomeController());

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Từ ngày:"),
                          Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 1),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Obx(() {
                                      return TextFormField(
                                        readOnly: true,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          hintText:
                                              "${dateRangeOverTimeController.dateRange.value.start.day}/${dateRangeOverTimeController.dateRange.value.start.month}/${dateRangeOverTimeController.dateRange.value.start.year}",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[410]),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          suffixIcon: InkWell(
                                            onTap: () =>
                                                dateRangeOverTimeController
                                                    .pickDateRange(context),
                                            child: const Icon(
                                                Icons.calendar_month_rounded),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              dateRangeOverTimeController.updateDateRange(
                                DateTimeRange(
                                  start: DateTime(DateTime.now().year, 1, 1),
                                  end: DateTime.now(),
                                ),
                              );
                            },
                            label: const Text("Xóa bộ lọc",
                                style: TextStyle(color: Colors.black)),
                            icon: const Icon(Icons.filter_alt_off,
                                color: Colors.black),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.grey, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4), // Điều chỉnh padding
                              minimumSize: const Size(130, 40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("Đến ngày:"),
                          Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 1),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Obx(() {
                                      return TextFormField(
                                        readOnly: true,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                            hintText:
                                                "${dateRangeOverTimeController.dateRange.value.end.day}/${dateRangeOverTimeController.dateRange.value.end.month}/${dateRangeOverTimeController.dateRange.value.end.year}",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[410]),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            suffixIcon: InkWell(
                                              onTap: () =>
                                                  dateRangeOverTimeController
                                                      .pickDateRange(context),
                                              child: const Icon(
                                                  Icons.calendar_month_rounded),
                                            )),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await statisticController.fetchFilterIncome();
                            },
                            label: const Text("Tìm kiếm",
                                style: TextStyle(color: Colors.black)),
                            icon: const Icon(Icons.search, color: Colors.black),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.grey, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4), // Điều chỉnh padding
                              minimumSize: const Size(130, 40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
