import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/widget/selected_voucher_item.dart';
import 'package:food_delivery_h2d/features/customers/search/views/widgets/widget_search_bar.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SelectVoucherScreen extends StatefulWidget {
  const SelectVoucherScreen({super.key, this.selectedVoucher});

  final VoucherModel? selectedVoucher;

  @override
  State<SelectVoucherScreen> createState() => _SelectVoucherScreenState();
}

class _SelectVoucherScreenState extends State<SelectVoucherScreen> {
  late final ValueNotifier<VoucherModel?> selectedVoucherNotifier;
  final _searchController = TextEditingController();

  final orderController = OrderController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.getVouchersInOrder();
    });
    selectedVoucherNotifier =
        ValueNotifier<VoucherModel?>(widget.selectedVoucher);
  }

  Widget _buildSelectVoucherList() {
    final items = orderController.vouchers;
    return ValueListenableBuilder<VoucherModel?>(
      valueListenable: selectedVoucherNotifier,
      builder: (context, value, _) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return SelectedVoucherItem(
              voucherModel: item,
              groupValue: value,
              onChanged: (voucher) {
                selectedVoucherNotifier.value = voucher;
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(
            color: MyColors.dividerColor,
            thickness: 0.1,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
        appBar: CustomAppBar(
          handleBack: () {
            Navigator.of(context).pop();
          },
          title: const Text("Chọn mã giảm giá"),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.save,
                  size: MySizes.iconMd,
                ),
                onPressed: () {
                  print(selectedVoucherNotifier.value?.code);
                  Navigator.of(context).pop(selectedVoucherNotifier.value);
                }),
          ],
        ),
        body: Obx(
          () => orderController.isGetVouchersLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(MySizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: WidgetSearchBar(
                                controller: _searchController,
                                hintText: "Nhập voucher",
                              ),
                            ),
                            const SizedBox(
                              width: MySizes.sm,
                            ),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    orderController.getVoucherByCode(
                                        _searchController.text.trim());
                                  },
                                  child: const Text("Áp dụng")),
                            )
                          ],
                        ),
                        _buildSelectVoucherList()
                      ],
                    ),
                  ),
                ),
        ));
  }
}
