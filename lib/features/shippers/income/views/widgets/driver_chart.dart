import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:food_delivery_h2d/features/shippers/income/controllers/income_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class DriverChart extends StatelessWidget {
  const DriverChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IncomeController());

    return Scaffold(
      body: Card(
        elevation: 6,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: MySizes.md),
                child: Center(
                  child: Text(
                    'Biểu đồ Thống kê trạng thái đơn hàng',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: MyColors.secondaryTextColor,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                width: 250,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final completedOrders =
                      controller.totalCompletedOrders.toDouble();
                  final cancelledOrders = controller.totalFailedOrders.toDouble();
                  final total = controller.totalOrders.toDouble();
                  final deliveringOrder = total - (completedOrders + cancelledOrders);
                    
                  return PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 30,
                      sections: [
                        PieChartSectionData(
                          value: completedOrders,
                          title: '${((completedOrders / total) * 100).toStringAsFixed(1)}%',
                          color: Colors.green,
                          radius: controller.touchedIndex.value == 0 ? 105 : 75,
                          titleStyle: TextStyle(
                            fontSize:
                                controller.touchedIndex.value == 0 ? 16 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: cancelledOrders,
                          title: '${((cancelledOrders / total) * 100).toStringAsFixed(1)}%',
                          color: MyColors.primaryColor,
                          radius: controller.touchedIndex.value == 1 ? 105 : 75,
                          titleStyle: TextStyle(
                            fontSize:
                                controller.touchedIndex.value == 1 ? 16 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: deliveringOrder,
                          title: '${((deliveringOrder / total) * 100).toStringAsFixed(1)}%',
                          color: Colors.orange,
                          radius: controller.touchedIndex.value == 2 ? 105 : 75,
                          titleStyle: TextStyle(
                            fontSize:
                                controller.touchedIndex.value == 2 ? 16 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      borderData: FlBorderData(show: false),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            controller.updateTouchedIndex(-1);
                            return;
                          }
                          controller.updateTouchedIndex(pieTouchResponse
                              .touchedSection!.touchedSectionIndex);
                        },
                      ),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 500),
                    swapAnimationCurve: Curves.easeInOut,
                  );
                }),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      bottom: MySizes.md, left: MySizes.md, right: MySizes.md),
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.only(right: MySizes.xs),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Text(
                            'Hoàn thành',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.only(right: MySizes.xs),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Text(
                            'Đang giao',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.only(right: MySizes.xs),
                            decoration: const BoxDecoration(
                              color: MyColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Text(
                            'Hủy',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
