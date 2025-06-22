import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartnerTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  final List<Tab> myTabs = <Tab>[
    const Tab(
      text: "Thông tin người đại diện",
    ),
    const Tab(
      text: "Địa chỉ hoạt động",
    ),
    const Tab(
      text: "Thông tin chi tiết quán",
    ),
  ];

  final myTabViews = <TabBarView>[];

  @override
  void onInit() {
    controller = TabController(length: myTabs.length, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void next() {
    int nextIndex = (controller.index + 1) % 3;
    controller.animateTo(nextIndex);
  }
}
