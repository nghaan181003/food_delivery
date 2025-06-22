import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/side_bar/controllers/side_bar_controller.dart';
import 'package:food_delivery_h2d/routes/routes.dart';
import 'package:get/get.dart';

class RouteObserver extends GetObserver{
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sideBarController = Get.put(SideBarController());
    if (previousRoute != null) {
      print("hello");
      for (var routeName in Routes.sideBarItems) {
        if (previousRoute.settings.name == routeName) {
          sideBarController.activeItem.value = routeName;
        }
      }
    }

  }
}