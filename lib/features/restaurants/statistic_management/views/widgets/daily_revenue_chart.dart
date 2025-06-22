import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/daily_revenue_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/daily_revenue.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyRevenueScreen extends StatelessWidget {
  MonthlyRevenueScreen({super.key});
  final controller = Get.put(DailyRevenueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        elevation: 6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: MySizes.md),
              child: Text(
                'Biểu đồ Thống kê doanh thu hàng ngày',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MyColors.secondaryTextColor,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(MySizes.md),
              child: Obx(() {
                final date = controller.selectedDate.value;
                return SizedBox(
                  width: 150,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('MM/yyyy').format(date),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Chọn tháng',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await showMonthYearPicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (picked != null) {
                        controller.pickNewDate(picked);
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              } else if (controller.revenueList.isEmpty) {
                return const Text("Không có dữ liệu trong tháng này");
              } else {
                return SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: controller.revenueList.length * 25 + 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  preventCurveOverShooting: true,
                                  spots: controller.revenueList.map((model) {
                                    final day = model.date.day.toDouble();
                                    return FlSpot(day, model.revenue);
                                  }).toList(),
                                  isCurved: true,
                                  color: MyColors.darkPrimaryColor,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.red.withOpacity(0.2),
                                  ),
                                ),
                              ],
                              minX: 1,
                              maxY: controller.revenueList
                                      .map((e) => e.revenue)
                                      .reduce((a, b) => a > b ? a : b) *
                                  1.2,
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      if (value % 100000 == 0) {
                                        return Text(
                                            MyFormatter.formatCurrency(
                                                value.toInt()),
                                            style:
                                                const TextStyle(fontSize: 10));
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(show: true),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3)),
                              ),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipRoundedRadius: 8,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots
                                        .map((LineBarSpot touchedSpot) {
                                      final day = touchedSpot.x.toInt();
                                      final model = controller.revenueList
                                          .firstWhereOrNull(
                                        (e) => e.date.day == day,
                                      );

                                      final dateStr = model != null
                                          ? DateFormat('dd/MM/yyyy')
                                              .format(model.date)
                                          : 'Ngày $day';

                                      return LineTooltipItem(
                                        '$dateStr\n${MyFormatter.formatCurrency(touchedSpot.y.toInt())}',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
