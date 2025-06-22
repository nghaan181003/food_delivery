import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/paginate/custom_paginate.dart';
import 'package:food_delivery_h2d/common/widgets/paginate/default_pagination.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/controller/topping_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/edit_topping_group_view.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/topping_group_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ToppingGroupList extends StatefulWidget {
  ToppingGroupList({super.key});

  @override
  State<ToppingGroupList> createState() => _ToppingGroupListState();
}

class _ToppingGroupListState extends State<ToppingGroupList> {
  late ToppingController toppingController;
  late ScrollController controller = ScrollController();

  @override
  void initState() {
    toppingController = Get.find<ToppingController>();
    controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      toppingController.getToppingsGpsV2();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => toppingController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(child: Obx(() => _buildToppingGps)),
                _buildAddToppingGroup,
                const SizedBox(
                  height: 16,
                )
              ],
            ),
    );
  }

  Widget get _buildToppingGps {
    var toppingGps = toppingController.toppingGps;
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        controller: controller,
        itemCount: toppingGps.length,
        itemBuilder: (_, index) {
          if (index < toppingGps.length) {
            final toppingGp = toppingGps[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: MySizes.sm),
              child: _buildToppingGroupItem(toppingGp),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget _buildToppingGroupItem(Rx<ToppingGroupModel> item) {
    return ToppingGroupItem(
      onTap: () => Get.to(() => EditToppingGroupView(
            toppingGroup: item,
          )),
      toppingGroup: item,
    );
  }

  Widget get _buildAddToppingGroup {
    return TextButton(
        onPressed: () {
          Get.to(() => EditToppingGroupView(
                toppingGroup: ToppingGroupModel().obs,
              ));
        },
        child: const Column(
          children: [
            Icon(
              Icons.add,
              color: MyColors.darkPrimaryColor,
            ),
            SizedBox(
              height: MySizes.sm,
            ),
            Text("Thêm nhóm topping"),
          ],
        ));
  }
}
