import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/category/category_selector.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/common/widgets/shimmers/shimmer_list_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/controller/discount_management_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/discount_detail_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/discount_item.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class DiscountManagementTab extends StatefulWidget {
  const DiscountManagementTab({super.key});

  @override
  State<DiscountManagementTab> createState() => _DiscountManagementTabState();
}

class _DiscountManagementTabState extends State<DiscountManagementTab> {
  final _controller = Get.put(DiscountManagementController());

  @override
  void initState() {
    super.initState();
    _controller.getDiscounts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<DiscountManagementController>();
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      body: Obx(
        () => Column(
          children: [
            const SizedBox(height: MySizes.md),
            _buildCategorySelector(),
            const SizedBox(height: MySizes.md),
            Expanded(child: _buildDiscountList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return CategorySelector<DiscountStatus>(
      categories: DiscountStatus.values,
      selectedItem: _controller.selectedDiscountStatus,
      labelBuilder: (status) => status.toEntityString,
      onChanged: (status) {
        if (status != _controller.selectedDiscountStatus) {
          _controller.selectedDiscountStatus = status;
          _controller.getDiscounts();
        }
      },
    );
  }

  Widget _buildDiscountList() {
    if (_controller.isLoading.value) {
      return const ShimmerListTile();
    }

    if (_controller.discounts.isEmpty) {
      return const Center(
        child: Text(
          'Không có chương trình khuyến mãi nào 🫶',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _controller.discounts.length,
      itemBuilder: (context, index) {
        final discount = _controller.discounts[index];
        return DiscountItem(
          discountModel: discount,
          onViewDetail: () => Get.to(() => DiscountDetailScreen(
                discountModel: discount,
                onCancel: () async {
                  if (discount.id != null) {
                    final result = await _controller.onCancel(id: discount.id!);
                    if (result) {
                      Navigator.of(context).pop();
                      _controller.getDiscounts();
                    }
                  }
                },
                onRestart: () {},
              )),
        );
      },
    );
  }
}
