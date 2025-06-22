import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/loaders/animation_loader.dart';
import 'package:get/get.dart';


class FullScreenLoader {
  static void openDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!, // hien thi overlay dialog
        barrierDismissible: false, // dialog k dismiss thi click o ngoai

        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  AnimationLoaderWidget(text: text, animation: animation)
                ],
              ),
            )));
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
