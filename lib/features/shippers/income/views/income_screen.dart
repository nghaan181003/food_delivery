import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/shippers/income/controllers/income_controller.dart';
import 'package:food_delivery_h2d/features/shippers/income/views/widgets/driver_chart.dart';
import 'package:food_delivery_h2d/features/shippers/income/views/widgets/driver_statistic_widget.dart';
import 'package:food_delivery_h2d/features/shippers/income/views/widgets/filter_widget.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incomeController = Get.put(IncomeController());
    return Scaffold(
        appBar: const CustomAppBar(
          title: Text("Thu nhập"),
          showBackArrow: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const DriverFilterWidget(),
              const SizedBox(
                height: MySizes.spaceBtwItems/2,
              ),
              const Padding(
                padding: EdgeInsets.all(MySizes.sm),
                child: DriverStatisticWidget(),
              ),
   
              Obx(() {
                if (incomeController.errorMessage.isNotEmpty) {
                  return const Center(
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return SizedBox(
                  height: 430,
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                    padding: EdgeInsets.all(MySizes.sm),
                    child: DriverChart(),
                  ),
                );
              })
            ],
          ),
        ));
  }
}
