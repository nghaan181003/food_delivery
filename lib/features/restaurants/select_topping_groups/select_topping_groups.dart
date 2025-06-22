import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/features/restaurants/select_topping_groups/controllers/select_topping_group_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/select_topping_groups/controllers/select_topping_group_state.dart';
import 'package:food_delivery_h2d/features/restaurants/select_topping_groups/widgets/select_topping_group_item.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';

class SelectToppingGroups extends StatefulWidget {
  const SelectToppingGroups({super.key, required this.itemId});

  final String itemId;

  @override
  State<SelectToppingGroups> createState() => _SelectToppingGroupsState();
}

class _SelectToppingGroupsState extends State<SelectToppingGroups> {
  late final SelectToppingGroupController _controller;
  @override
  initState() {
    super.initState();
    _controller = Get.put(SelectToppingGroupController(itemId: widget.itemId));
    ever(_controller.resultStatus, (result) {
      if (result != null) {
        if (result.$1) {
          Loaders.successSnackBar(title: "Thành công", message: result.$2);
        } else {
          Loaders.errorSnackBar(title: "Thất bại", message: result.$2);
        }
      }
    });
  }

  Widget _buildToppingGroupList(
      {required BuildContext context,
      required List<ToppingGroupModel> toppingGroups,
      required bool isLinked}) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: toppingGroups.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final tpg = toppingGroups[index];
        return SelectToppingGroupItem(
          toppingGroup: tpg,
          value: isLinked,
          onChanged: (value) {
            _controller.toggleToppingGroup(tpg);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(color: MyColors.dividerColor, thickness: 0.1);
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
          title: const Text("Nhóm Topping"),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.save,
                  size: MySizes.iconMd,
                ),
                onPressed: () => _controller.onSaveLinkToppingGroups()),
          ],
        ),
        body: Obx(() {
          final _state = _controller.state.value;
          switch (_state.status) {
            case SelectToppingGroupStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case SelectToppingGroupStatus.failed:
              return Loaders.errorSnackBar(
                  title: "Lỗi", message: _state.message);

            case SelectToppingGroupStatus.fetched:
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(MySizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Đã liên kết
                      const Text("Đã liên kết"),
                      _buildToppingGroupList(
                          context: context,
                          toppingGroups: _controller.linkedToppingGroups,
                          isLinked: true),
                      const SizedBox(
                        height: MySizes.spaceBtwItems,
                      ),
                      const Text("Chưa liên kết"),
                      _buildToppingGroupList(
                          context: context,
                          toppingGroups: _controller.unLinkedToppingGroups,
                          isLinked: false),
                    ],
                  ),
                ),
              );
            case SelectToppingGroupStatus.initial:
              return const SizedBox.shrink();
            case SelectToppingGroupStatus.linkToppingSuccess:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.back();
                Loaders.successSnackBar(
                    title: "Thành công!", message: _state.message);
              });
              return const SizedBox.shrink();
            default:
              return const SizedBox.shrink();
          }
        }));
  }
}
