import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/controller/select_product_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/apply_product_item.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppliesToScreen extends StatefulWidget {
  const AppliesToScreen({super.key, required this.selectProductIdx});

  final List<String> selectProductIdx;

  @override
  State<AppliesToScreen> createState() => _AppliesToScreenState();
}

class _AppliesToScreenState extends State<AppliesToScreen> {
  final selectProductController = Get.put(SelectProductController());

  late final ValueNotifier<List<String>> selectProductIdxNotifier;
  @override
  initState() {
    super.initState();
    selectProductController.getProducts();
    selectProductIdxNotifier = ValueNotifier(widget.selectProductIdx);
  }

  Widget _buildSelectItemList() {
    final items = selectProductController.items;
    return ValueListenableBuilder<List<String>>(
      valueListenable: selectProductIdxNotifier,
      builder: (context, selectedIds, _) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selectedIds.contains(item.itemId);
            return ApplyProductItem(
              item: item,
              value: isSelected,
              onChanged: (checked) {
                final currentList = List<String>.from(selectedIds);
                if (checked ?? false) {
                  currentList.add(item.itemId);
                } else {
                  currentList.remove(item.itemId);
                }
                selectProductIdxNotifier.value = currentList;
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
            Get.back();
          },
          title: const Text("Món giảm giá"),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.save,
                  size: MySizes.iconMd,
                ),
                onPressed: () {
                  Navigator.of(context).pop(selectProductIdxNotifier.value);
                }),
          ],
        ),
        body: Obx(
          () => selectProductController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(MySizes.sm),
                    child: Column(
                      children: [_buildSelectItemList()],
                    ),
                  ),
                ),
        ));
  }
}
