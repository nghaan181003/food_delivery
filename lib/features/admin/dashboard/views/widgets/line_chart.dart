import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/controllers/month_year_picker_controller.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/controllers/user_management_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';

class StatisticLineChart extends StatelessWidget {
  StatisticLineChart({super.key});
  final UserManagementController userController =
      Get.put(UserManagementController());
  final MonthYearPickerController monthYearController =
      Get.put(MonthYearPickerController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Card(
        elevation: 4,
        shadowColor: MyColors.darkPrimaryColor,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    controller: monthYearController.dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        size: MySizes.iconSm,
                      ),
                      labelText: 'Chọn tháng',
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime(
                          monthYearController.selectedYear.value,
                          monthYearController.selectedMonth.value,
                        ),
                        firstDate: DateTime(DateTime.now().year - 20),
                        lastDate: DateTime(DateTime.now().year + 20),
                      );
                      if (pickedDate != null) {
                        monthYearController.updateDate(pickedDate);
                        userController.selectedMonth.value =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}";
                      }
                    },
                  ),
                )),
            Text(
              'Biểu đồ Thống kê số lượng người đăng ký theo tháng',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: MyColors.secondaryTextColor,
                  ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  final chartData = userController.getFilteredChartData();

                  if (chartData.isEmpty) {
                    return const Center(child: Text('Không có dữ liệu.'));
                  }

                  return LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          preventCurveOverShooting: true,
                          spots: chartData.asMap().entries.map((entry) {
                            final index = entry.key.toDouble();
                            final data = entry.value;
                            return FlSpot(index, data.count.toDouble());
                          }).toList(),
                          isCurved: true,
                          color: MyColors.darkPrimaryColor,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: MyColors.darkPrimaryColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                      maxY: chartData.map((e) => e.count).fold<int>(0, (a, b) => a > b ? a : b) + 2,

                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < chartData.length) {
                                return Text(
                                  chartData[index].xData,
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                            reservedSize: 30,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles:
                                false, // Ẩn tất cả giá trị trên hàng ngang
                            reservedSize: 30,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles:
                                false, // Ẩn tất cả giá trị trên hàng ngang
                            reservedSize: 30,
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: true),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
