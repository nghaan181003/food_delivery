import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_delivery_h2d/common/widgets/images/circular_image.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class DiscountItem extends StatelessWidget {
  const DiscountItem(
      {super.key, required this.discountModel, this.onViewDetail});

  final DiscountModel discountModel;
  final VoidCallback? onViewDetail;

  Widget _buildContent(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: MyColors.secondaryTextColor, fontWeight: FontWeight.w300);
    return Row(
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
                      discountModel.name ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thời gian ",
                          style: titleStyle,
                        ),
                        Text(
                            "${discountModel.startDate.formatDMY_HM} - ${discountModel.endDate.formatDMY_HM}")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Tạo bởi ",
                          style: titleStyle,
                        ),
                        const Text("Quán tạo/Đăng ký")
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
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  /* 
  OutlinedButton.styleFrom(
              elevation: 0,
              foregroundColor: MyColors.darkPrimaryColor,
              side:
                  const BorderSide(color: MyColors.darkPrimaryColor, width: 2),
              textStyle: const TextStyle(
                  fontSize: 16,
                  color: MyColors.darkPrimaryColor,
                  fontWeight: FontWeight.w600),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(MySizes.borderRadiusLg)))
  
  */
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
                              (discountModel.status ?? DiscountStatus.all)
                                  .toEntityString,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: (discountModel.status ??
                                              DiscountStatus.all)
                                          .toColor),
                            ),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    side: const BorderSide(
                                        color: MyColors.secondaryTextColor,
                                        width: 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MySizes.borderRadiusMd))),
                                onPressed: onViewDetail,
                                child: const Text(
                                  "Chi tiết ",
                                  style: TextStyle(
                                      color: MyColors.primaryTextColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                ))
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
                    "Joodies | Gạch giá",
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
