import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/controllers/user_management_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:get/get.dart';

class UserRoleChart extends StatelessWidget {
  const UserRoleChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserManagementController());

    return Padding(
        padding: const EdgeInsets.only(left: MySizes.lg),
        child: Card(
          elevation: 4,
          shadowColor: MyColors.darkPrimaryColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Biểu đồ thống kê người dùng theo vai trò',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: MyColors.secondaryTextColor,
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
                  if (controller.userList.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu người dùng.'),
                    );
                  }
                  final data = controller.getPieChartData();
                  return PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final sectionData = entry.value;
                        final isTouched =
                            index == controller.touchedIndex.value;
                        final double fontSize = isTouched ? 16.0 : 13.0;
                        final double radius = isTouched ? 105.0 : 75.0;

                        final title = isTouched
                            ? '${ConvertEnumRole.roleToDisplayName(sectionData.xData)}: ${sectionData.count}\n${MyFormatter.formatDouble(double.parse(sectionData.yData))}%\n'
                            : '${MyFormatter.formatDouble(double.parse(sectionData.yData))}%';

                        return PieChartSectionData(
                          color:
                              ConvertEnumRole.getColorByRole(sectionData.xData),
                          value: double.parse(sectionData.yData),
                          title: title,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          radius: radius,
                          badgePositionPercentageOffset: .98,
                        );
                      }).toList(),
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
              Obx(() {
                final data = controller.getPieChartData();
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: MySizes.md, left: MySizes.md, right: MySizes.md),
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: data.map((sectionData) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.only(right: MySizes.xs),
                            decoration: BoxDecoration(
                              color: ConvertEnumRole.getColorByRole(
                                  sectionData.xData),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            ConvertEnumRole.roleToDisplayName(
                                sectionData.xData),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          ),
        ),
      );
  }
}
