import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/top_selling_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'dart:math';

class TopSellingBarChart extends StatelessWidget {
  const TopSellingBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopSellingController());
    const barWidth = 22.0;

    return Scaffold(
      body: Card(
        elevation: 6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: MySizes.md),
              child: Text(
                'Biểu đồ Thống kê các món bán chạy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MyColors.secondaryTextColor,
                    ),
              ),
            ),
            const SizedBox(
              height: MySizes.spaceBtwItems,
            ),
            SizedBox(
              height: 540,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.isNotEmpty) {
                  return Center(
                      child: Text('Lỗi: ${controller.errorMessage}'));
                } else if (controller.list.isEmpty) {
                  return const Center(child: Text("Chưa có món ăn"),);
                } 
                else {
                  final data = controller.list;
        
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: max(data.length * 60.0, 400),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: BarChart(
                          BarChartData(
                            maxY: (data
                                        .map((e) => e.sales)
                                        .reduce((a, b) => a > b ? a : b) +
                                    5)
                                .toDouble(),
                            gridData: const FlGridData(show: false),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  final item = data[groupIndex];
                                  return BarTooltipItem(
                                    '${item.itemName}\nĐã bán: ${item.sales}',
                                    const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 80,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index < data.length) {
                                      return SizedBox(
                                        width: 50,
                                        child: Text(
                                          data[index].itemName,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: MyColors
                                                      .darkPrimaryTextColor),
                                                      
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 5,
                                  reservedSize: 20,
                                  getTitlesWidget: (value, meta) =>
                                      Text('${value.toInt()}'),
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              border: const Border(
                                bottom: BorderSide(width: 1),
                                left: BorderSide(width: 1),
                              ),
                            ),
                            barGroups: data.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: item.sales.toDouble(),
                                    color: MyColors.darkPrimaryColor,
                                    width: barWidth,
                                    borderRadius: BorderRadius.zero,
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
