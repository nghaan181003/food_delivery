import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class OrderStatusController extends GetxController {
  var container1Progress = 0.0.obs;
  var container2Progress = 0.0.obs;
  var container3Progress = 0.0.obs;
  var orderStatus = 'waiting'.obs;

  late Timer _progressTimer;

  @override
  void onInit() {
    super.onInit();
    _startProgress();
  }

  @override
  void onClose() {
    _progressTimer.cancel();
    super.onClose();
  }


  void _startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (orderStatus.value == 'waiting' ||
          orderStatus.value == 'heading_to_rest') {
        if (container1Progress.value < 1.0) {
          container1Progress.value += 0.01; // Increase progress
        } else {
          container1Progress.value = 0.0;
        }
      } else if (orderStatus.value == 'preparing') {
        container1Progress.value = 1.0;
        container3Progress.value = 0.0;

        if (container2Progress.value < 1.0) {
          container2Progress.value += 0.01;
        } else {
          container2Progress.value = 0.0;
        }
      } else if (orderStatus.value == 'delivering') {
        container1Progress.value = 1.0;
        container2Progress.value = 1.0;

        if (container3Progress.value < 1.0) {
          container3Progress.value += 0.01; // Increase progress
        } else {
          container3Progress.value = 0.0;
        }
      } else if (orderStatus.value == 'delivered') {
        orderStatus.value = 'delivered';
        container1Progress.value = 1.0;
        container2Progress.value = 1.0;
        container3Progress.value = 1.0;
        _progressTimer.cancel();
      } else {
        container1Progress.value = 1.0;
        container2Progress.value = 1.0;
        container3Progress.value = 1.0;
      }
    });

  }

  void updateProgress(String status) {
    if (status == 'waiting') {
      container1Progress.value = 0.0;
      container2Progress.value = 0.0;
      container3Progress.value = 0.0;
    } else if (status == 'preparing') {
      container1Progress.value = 1.0;
      container2Progress.value = 0.0;
      container3Progress.value = 0.0;
    } else if (status == 'delivering') {
      container1Progress.value = 1.0;
      container2Progress.value = 1.0;
      container3Progress.value = 0.0;
    }
    orderStatus.value = status;
  }

  Color getContainerColor(int container) {
    if (container == 1) {
      return orderStatus.value == 'waiting' || orderStatus.value == 'preparing'
          ? MyColors.primaryColor
          : Colors.grey;
    } else if (container == 2) {
      return orderStatus.value == 'preparing' ||
              orderStatus.value == 'delivering'
          ? MyColors.primaryColor
          : Colors.grey;
    } else {
      return orderStatus.value == 'delivering'
          ? MyColors.primaryColor
          : Colors.grey;
    }
  }
}
