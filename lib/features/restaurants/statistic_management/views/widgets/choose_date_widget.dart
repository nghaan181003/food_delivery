import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/date_range_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/statistic_controller.dart';
import 'package:get/get.dart';

class ChooseDateWidget extends StatelessWidget implements PreferredSizeWidget {
  const ChooseDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRangeOverTimeController =
        Get.put(RestaurantDateRangeController());
    final statisticController = Get.put(StatisticController());

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
                          const Text("Lọc từ ngày:"),
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
                                        ),
                                      );
                                    }),
                                  ),
                                  IconButton(
                                    onPressed: () => dateRangeOverTimeController
                                        .pickDateRange(context),
                                    icon: const Icon(
                                        Icons.calendar_month_rounded),
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
                          const Text("Lọc đến ngày:"),
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
                                        ),
                                      );
                                    }),
                                  ),
                                  IconButton(
                                    onPressed: () => dateRangeOverTimeController
                                        .pickDateRange(context),
                                    icon: const Icon(
                                        Icons.calendar_month_rounded),
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
