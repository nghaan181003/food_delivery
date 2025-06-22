import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/features/customers/order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CustomerRatingController extends GetxController {
  static CustomerRatingController get instance => Get.find();

  final commentRestaurant = TextEditingController();
  final commentDriver = TextEditingController();

  final RxDouble selectedRatingRestaurant = 5.0.obs;
  final RxDouble selectedRatingDriver = 5.0.obs;

  final OrderRepository orderRepository = Get.put(OrderRepository());
  final orderController = Get.put(CustomerOrderController());

  final List<String> reviewSuggestionsRatingRes = [
    "Món ăn ngon, đẹp mắt",
    "Giao đủ món",
    "Đóng gói kỹ càng",
    "Giá cả hợp lý",
  ];

  final List<String> reviewSuggestionsRatingDriver = [
    "Giao hàng nhanh",
    "Thái độ phục vụ tốt",
  ];

  final RxList<String> selectedSuggestions = <String>[].obs;

  void toggleSuggestion(String suggestion, TextEditingController controller) {
    if (selectedSuggestions.contains(suggestion)) {
      selectedSuggestions.remove(suggestion);
      controller.text = controller.text
          .replaceAll("$suggestion, ", "")
          .replaceAll(suggestion, "");
    } else {
      selectedSuggestions.add(suggestion);
      controller.text = controller.text.isEmpty
          ? suggestion
          : "${controller.text}, $suggestion";
    }
  }

  final RxList<String> selectedDriverSuggestions = <String>[].obs;

  void toggleDriverSuggestion(String suggestion, TextEditingController controller) {
    if (selectedDriverSuggestions.contains(suggestion)) {
      selectedDriverSuggestions.remove(suggestion);
      controller.text = controller.text
          .replaceAll("$suggestion, ", "")
          .replaceAll(suggestion, "");
    } else {
      selectedDriverSuggestions.add(suggestion);
      controller.text = controller.text.isEmpty
          ? suggestion
          : "${controller.text}, $suggestion";
    }
  }

  @override
  void onClose() {
    commentRestaurant.dispose();
    commentDriver.dispose();
    super.onClose();
  }

  Future rating(String orderId) async {
    try {
      FullScreenLoader.openDialog("Đang xử lý", MyImagePaths.spoonAnimation);

      double restaurantRating = selectedRatingRestaurant.value;
      double driverRating = selectedRatingDriver.value;
      String restaurantComment = commentRestaurant.text.trim();
      String driverComment = commentDriver.text.trim();

      await orderRepository.updateRating(
        orderId,
        restaurantRating,
        custResRatingComment:
            restaurantComment.isNotEmpty ? restaurantComment : "",
        custShipperRating: driverRating,
        custShipperRatingComment: driverComment.isNotEmpty ? driverComment : "",
      );
      orderController.fetchAllOrders();

      Get.back();
      Loaders.successSnackBar(
          title: "Thành công", message: "Đánh giá thành công");
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
