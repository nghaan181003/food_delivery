import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/top_item_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class TopItemBarChart extends StatelessWidget {
  const TopItemBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopItemController());
    const barWidth = 22.0;

    return Padding(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Card(
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
              height: 390,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.isNotEmpty) {
                  return Center(
                      child: Text('Lỗi: ${controller.errorMessage}'));
                } else if (controller.topItemList.isEmpty) {
                  return const Center(child: Text("Chưa có món ăn"),);
                } 
                else {
                  final data = controller.topItemList;
        
                  return SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: BarChart(
                        BarChartData(
                          maxY: (data
                                      .map((e) => e.sales)
                                      .reduce((a, b) => a > b ? a : b) +
                                  5)
                              .toDouble(),
                          gridData: const FlGridData(show: true),
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
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    
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
                                interval: 4,
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
