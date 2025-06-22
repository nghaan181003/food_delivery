import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/income/controllers/income_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class DriverStatisticWidget extends StatelessWidget {
  const DriverStatisticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final incomeController = Get.put(IncomeController());

    return Obx(() {
      if (incomeController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (incomeController.errorMessage.isNotEmpty) {
        return const Center(
          child: Text(
            "Không có đơn hàng trong khoảng thời gian này",
            style: TextStyle(color: Colors.red),
          ),
        );
      }
      return Card(
        elevation: 6,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(MyImagePaths.iconIncome, width: 20, height: 20,),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      "Tổng thu nhập: ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      MyFormatter.formatCurrency(
                          incomeController.totalIncome.toInt()),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: MySizes.sm,
                ),
                Row(
                  children: [
                    Image.asset(MyImagePaths.iconAllOrder, width: 20, height: 20,),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      "Tổng đơn đã nhận: ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      "${incomeController.totalOrders}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: MySizes.sm,
                ),
                Row(
                  children: [
                    Image.asset(MyImagePaths.iconDilivering, width: 20, height: 20,),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      "Đơn đang giao: ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      incomeController.totalDelivering.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: MySizes.sm,
                ),
                Row(
                  children: [
                    Image.asset(MyImagePaths.iconDoneOrder, width: 22, height: 22,),
                    const SizedBox(
                      width: MySizes.xs - 2,
                    ),
                    Text(
                      "Đơn giao thành công: ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      incomeController.totalCompletedOrders.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: MySizes.sm,
                ),
                Row(
                  children: [
                    Image.asset(MyImagePaths.iconCancelOrder, width: 20, height: 20,),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      "Đơn giao không thành công: ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(
                      width: MySizes.xs,
                    ),
                    Text(
                      incomeController.totalFailedOrders.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
