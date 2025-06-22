import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/controllers/daily_order_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyOrderChart extends StatelessWidget {
  DailyOrderChart({super.key});
  final controller = Get.put(DailyOrderController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Card(
        elevation: 6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: MySizes.md),
              child: Text(
                'Biểu đồ Thống kê đơn hàng hàng ngày',
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
              } else if (controller.orderList.isEmpty) {
                return const Text("Không có dữ liệu trong tháng này");
              } else {
                return SizedBox(
                  height: 380,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              // Delivered line
                              LineChartBarData(
                                preventCurveOverShooting: true,
                                spots: controller.orderList.map((model) {
                                  final day = model.date.day.toDouble();
                                  return FlSpot(
                                      day, model.delivered.toDouble());
                                }).toList(),
                                isCurved: false,
                                color: Colors.green,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.green.withOpacity(0.2),
                                ),
                              ),
                              // Cancelled line
                              LineChartBarData(
                                preventCurveOverShooting: true,
                                spots: controller.orderList.map((model) {
                                  final day = model.date.day.toDouble();
                                  return FlSpot(
                                      day, model.cancelled.toDouble());
                                }).toList(),
                                isCurved: false,
                                color: Colors.red,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.red.withOpacity(0.2),
                                ),
                              ),
                              // Delivering line
                              LineChartBarData(
                                preventCurveOverShooting: true,
                                spots: controller.orderList.map((model) {
                                  final day = model.date.day.toDouble();
                                  return FlSpot(
                                      day, model.delivering.toDouble());
                                }).toList(),
                                isCurved: false,
                                color: Colors.orange,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.orange.withOpacity(0.2),
                                ),
                              ),
                              LineChartBarData(
                                preventCurveOverShooting: true,
                                spots: controller.orderList.map((model) {
                                  final day = model.date.day.toDouble();
                                  return FlSpot(day, model.total.toDouble());
                                }).toList(),
                                isCurved: false,
                                color: Colors.purple,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.purple.withOpacity(0.2),
                                ),
                              ),
                            ],
                            minX: 1,
                            maxY: controller.orderList
                                    .map((e) => e.total)
                                    .reduce((a, b) => a > b ? a : b) *
                                1,
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
                                  interval: 10,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 10),
                                    );
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
                              handleBuiltInTouches: true,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipRoundedRadius: 8,
                                fitInsideHorizontally: true,
                                fitInsideVertically: true,
                                getTooltipItems: (touchedSpots) {
                                  if (touchedSpots.isEmpty) return [];

                                  final firstSpot = touchedSpots.first;
                                  final day = firstSpot.x.toInt();
                                  final model =
                                      controller.orderList.firstWhereOrNull(
                                    (e) => e.date.day == day,
                                  );

                                  if (model == null) return [];

                                  final dateStr = DateFormat('dd/MM/yyyy')
                                      .format(model.date);

                                  return touchedSpots.map((spot) {
                                    if (spot == firstSpot) {
                                      return LineTooltipItem(
                                        '$dateStr\n'
                                        'Tổng đơn: ${model.total}\n'
                                        'Đã giao: ${model.delivered}\n'
                                        'Đang giao: ${model.delivering}\n'
                                        'Đã huỷ: ${model.cancelled}',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return null;
                                    }
                                  }).toList();
                                },
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
