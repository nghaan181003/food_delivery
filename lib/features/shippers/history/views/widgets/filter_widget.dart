import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/container/rounded_container.dart';
import 'package:food_delivery_h2d/features/shippers/history/controllers/date_range_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/devices/devices_utils.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class FilterWidget extends StatelessWidget implements PreferredSizeWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRangeController = Get.put(DateRangeHistoryController());

    return Padding(
      padding: const EdgeInsets.all(MySizes.defaultSpace),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    dateRangeController.showWeekPicker();
                  },
                  child: MyRoundedContainer(
                    padding: const EdgeInsets.all(12),
                    borderColor: MyColors.darkPrimaryColor,
                    showBorder: true,
                    child: Obx(() {
                      return Text(
                        "${MyFormatter.formatDateTime(dateRangeController.dateRange.value.start)} - ${MyFormatter.formatDateTime(dateRangeController.dateRange.value.end)}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(
                width: MySizes.spaceBtwItems,
              ),
              MyRoundedContainer(
                  backgroundColor: MyColors.primaryColor,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(MyDeviceUtils.getAppBarHeight() * 1.8);
}
