import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_delivery_h2d/features/customers/search/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/voucher_item.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/formatter/currency.dart';

class SelectedVoucherItem extends StatelessWidget {
  const SelectedVoucherItem(
      {super.key,
      required this.voucherModel,
      required this.groupValue,
      this.onChanged});

  final VoucherModel voucherModel;
  final VoucherModel? groupValue;
  final ValueChanged<VoucherModel?>? onChanged;

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
            ),
            Radio<VoucherModel>(
              value: voucherModel,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
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
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(MySizes.sm),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _buildContent(context),
            ],
          ),
        ));
  }
}
