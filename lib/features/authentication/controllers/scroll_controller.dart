import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ScrollControllerX extends GetxController {
  var scrollPosition = 0.0.obs;
  late ScrollController controller;
  RxBool isVisibleImg = false.obs;
  @override
  void onInit() {
    super.onInit();
    controller = ScrollController()
      ..addListener(() {
        scrollPosition.value = controller.position.pixels;
      });
    Future.delayed(Duration(milliseconds: 500), () {
      isVisibleImg.value = true;
    });
  }

  bool isVisible(double offset) {
    return scrollPosition.value > offset;
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
