import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/category/category_selector.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/common/widgets/shimmers/shimmer_list_tile.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/create_discount_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/discount_management_tab.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/explore_tab.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/voucher_item.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/controller/voucher_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/view/create_voucher_screen.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/extension/context_extension.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VoucherOverviewScreen extends StatefulWidget {
  const VoucherOverviewScreen({super.key});

  @override
  State<VoucherOverviewScreen> createState() => _VoucherOverviewScreenState();
}

class _VoucherOverviewScreenState extends State<VoucherOverviewScreen> {
  final _controller = Get.put(VoucherController());
  @override
  void initState() {
    super.initState();
    _controller.getVouchers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      appBar: const CustomAppBar(
        title: Text("Danh sách mã giảm giá"),
      ),
      body: Obx(
        () => Column(
          children: [
            const SizedBox(height: MySizes.md),
            _buildCategorySelector(),
            const SizedBox(height: MySizes.md),
            Expanded(child: _buildVoucherList()),
          ],
        ),
      ),
      bottom: Row(
        children: [
          Expanded(
              child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => const CreateVoucherScreen());
                  },
                  child: const Text("Tạo voucher"))),
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

  Widget _buildCategorySelector() {
    return CategorySelector<VoucherStatus>(
      categories: VoucherStatus.values,
      selectedItem: _controller.selectedVoucherStatus,
      labelBuilder: (status) => status.toEntityString,
      onChanged: (status) {
        if (status != _controller.selectedVoucherStatus) {
          _controller.selectedVoucherStatus = status;
          _controller.getVouchers();
        }
      },
    );
  }

  Widget _buildVoucherList() {
    if (_controller.isLoading.value) {
      return const ShimmerListTile();
    }

    if (_controller.vouchers.isEmpty) {
      return const Center(
        child: Text(
          'Không có voucher nào 🫶',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _controller.vouchers.length,
      itemBuilder: (context, index) {
        final voucher = _controller.vouchers[index];
        return VoucherItem(
          voucherModel: voucher,
          onCancel: () async {
            final delete = await context.showDeleteConfirmationDialog(
              title: "Xóa voucher",
              message: 'Bạn có chắc chắn muốn xóa voucher này không?',
            );

            if (delete) {
              if (voucher.id != null) {
                final result = await _controller.onCancel(id: voucher.id!);
                if (result) {
                  _controller.getVouchers();
                }
              }
            }
          },
          onEdit: () {
            Get.to(() => CreateVoucherScreen(
                  voucher: voucher,
                ));
          },
        );
      },
    );
  }
}
