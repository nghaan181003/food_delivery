import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/dicount_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_type.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';

class DiscountDetailScreen extends StatelessWidget {
  DiscountDetailScreen(
      {super.key, required this.discountModel, this.onCancel, this.onRestart});

  final DiscountModel discountModel;

  final VoidCallback? onCancel;
  final VoidCallback? onRestart;

  final _now = DateTime.now();

  Widget _buildContainer({Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(MySizes.sm),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1))
          ]),
      child: child,
    );
  }

  Widget _buildRowWithLabel({required String title, required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        child
      ],
    );
  }

  Widget _buildOverview(BuildContext context) {
    final status = (discountModel.status ?? DiscountStatus.all);

    final statusColor = status.toColor;
    return _buildContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          discountModel.name ?? '',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
            "${discountModel.startDate.formatDMY_HM} - ${discountModel.endDate.formatDMY_HM}"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              color: statusColor.withOpacity(0.1),
              child: Text(
                  (discountModel.status ?? DiscountStatus.all).toEntityString),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              status.toDuration(
                  now: _now,
                  startTime: discountModel.startDate,
                  endTime: discountModel.endDate),
              style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
            )
          ],
        )
      ]
          .expand((e) => [
                e,
                const SizedBox(
                  height: MySizes.sm,
                )
              ])
          .toList()
        ..removeLast(),
    ));
  }

  Widget _buildDetail(BuildContext context) {
    return _buildContainer(
        child: Column(
      children: [
        _buildRowWithLabel(
            title: "Khuyến mãi cho", child: const Text("Tất cả khách hàng")),
        _buildRowWithLabel(title: "Người tạo", child: const Text("Quán")),
        _buildRowWithLabel(
            title: "Loại khuyến mãi",
            child: Text(discountModel.type.toEntityString)),
        _buildRowWithLabel(
            title: "Khuyến mãi áp dụng cho",
            child: Text(discountModel.appliesTo.toEntityString)),
      ]
          .expand((e) =>
              [e, const Divider(color: MyColors.dividerColor, thickness: 0.1)])
          .toList()
        ..removeLast(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    print("Offset: ${_now.timeZoneOffset}");
    return MobileWrapper(
      appBar: const CustomAppBar(
        title: Text("Chi tiết khuyến mãi"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.sm),
          child: Column(
            children: [_buildOverview(context), _buildDetail(context)]
                .expand((e) => [
                      e,
                      const SizedBox(
                        height: MySizes.spaceBtwSections,
                      )
                    ])
                .toList(),
          ),
        ),
      ),
      bottom: (discountModel.status ?? DiscountStatus.all).isCanceled ||
              (discountModel.status ?? DiscountStatus.all).isFinished
          ? null
          : Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: onCancel, child: const Text("Hủy"))),
                const SizedBox(
                  width: MySizes.sm,
                ),
                // Expanded(
                //     child: ElevatedButton(
                //         onPressed: onRestart, child: const Text("Khởi động lại"))),
              ],
            ),
    );
  }
}
