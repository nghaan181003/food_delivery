import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/common/widgets/images/circular_image.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/create_discount_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  Widget _buildHeader({required String title, bool isViewAll = false}) {
    final headerStyle = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(fontSize: 14, fontWeight: FontWeight.w500);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: headerStyle,
        ),
        if (isViewAll)
          Row(
            children: [
              Text(
                "Xem tất cả",
                style: headerStyle,
              ),
              const SizedBox(
                width: 2,
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 12,
                color: MyColors.primaryTextColor,
              )
            ],
          )
      ],
    );
  }

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

  Widget _buildDiscountProgram() {
    return Column(
      children: [
        _buildHeader(title: "Chương trình khuyễn mãi", isViewAll: true),
        const SizedBox(
          height: MySizes.spaceBtwItems,
        ),
        _buildContainer(child: const Column())
      ],
    );
  }

  Widget _buildOwnDiscount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(title: "Tự tạo khuyến mãi"),
        const SizedBox(
          height: MySizes.spaceBtwItems,
        ),
        _buildContainer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Joodies",
            ),
            Row(
              children: [
                const MyCircularImage(
                  width: 40,
                  height: 40,
                  image: MyImagePaths.discountImage,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Khuyến mãi gạch giá",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Text(
                              "Thiết lập giảm giá cho các món của quán",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: MySizes.sm,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: MyColors.dividerColor,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MySizes.md),
      decoration: const BoxDecoration(color: MyColors.greyWhite),
      child: Column(
        children: [
          _buildDiscountProgram(),
          InkWell(
              onTap: () => Get.to(() => const CreateDiscountScreen()),
              child: _buildOwnDiscount())
        ],
      ),
    );
  }
}
