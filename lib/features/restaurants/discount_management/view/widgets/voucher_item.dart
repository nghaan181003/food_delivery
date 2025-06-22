import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_delivery_h2d/common/widgets/images/circular_image.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/widgets/order_detail_widget.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';

class VoucherItem extends StatelessWidget {
  const VoucherItem(
      {super.key, required this.voucherModel, this.onCancel, this.onEdit});

  final VoucherModel voucherModel;
  final VoidCallback? onCancel;
  final VoidCallback? onEdit;

  Widget _buildContent(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: MyColors.secondaryTextColor, fontWeight: FontWeight.w300);
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                child: SvgPicture.asset(
                  MyImagePaths.priceSlashDiscountImgae,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              width: MySizes.sm,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucherModel.name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                            "${voucherModel.startDate?.formatDMY_HM} - ${voucherModel.endDate?.formatDMY_HM}"),
                        Row(
                          children: [
                            Text(
                              "Giá trị ",
                              style: titleStyle,
                            ),
                            Text(voucherModel.formattedValue)
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Đơn hàng tối thiểu: ",
                              style: titleStyle,
                            ),
                            Text(voucherModel.minOrdervalue?.formatCurrency ??
                                "")
                          ],
                        ),
                      ]
                          .expand((e) => [
                                e,
                                const SizedBox(
                                  height: MySizes.sm,
                                )
                              ])
                          .toList()
                        ..removeLast(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: MySizes.sm,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MySizes.md),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(MySizes.sm),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        _buildContent(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (voucherModel.status ?? VoucherStatus.all)
                                  .toEntityString,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: (voucherModel.status ??
                                              VoucherStatus.all)
                                          .toColor),
                            ),
                            if (voucherModel.isShowActions)
                              Row(
                                children: [
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          side: const BorderSide(
                                              color:
                                                  MyColors.secondaryTextColor,
                                              width: 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MySizes.borderRadiusMd))),
                                      onPressed: onCancel,
                                      child: const Text(
                                        "Hủy",
                                        style: TextStyle(
                                            color: MyColors.primaryTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      )),
                                  const SizedBox(
                                    width: MySizes.sm,
                                  ),
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          side: const BorderSide(
                                              color:
                                                  MyColors.secondaryTextColor,
                                              width: 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MySizes.borderRadiusMd))),
                                      onPressed: onEdit,
                                      child: const Text(
                                        "Sửa",
                                        style: TextStyle(
                                            color: MyColors.primaryTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      )),
                                ],
                              )
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: MyColors.lightPrimaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(12), // adjust radius as needed
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.food_bank,
                    color: MyColors.primaryColor,
                    size: 14,
                  ),
                  Text(
                    "Joodies | Voucher",
                    style: TextStyle(
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
