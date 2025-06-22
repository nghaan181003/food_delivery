import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  final List<Tab> myTabs = <Tab>[
    const Tab(
      text: "Thông tin cơ bản",
    ),
    const Tab(
      text: "Thông tin cư trú",
    ),
    const Tab(
      text: "Bằng lái & phương tiện",
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
