import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:get/get.dart';

class FollowOrderController extends GetxController {
  static FollowOrderController get instance => Get.find();
  final orderRepository = Get.put(OrderRepository());

  var order = Rxn<Order>();
  var isLoading = false.obs;
  var isButtonClicked = false.obs;
  var isExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['order'] != null) {
      order.value = Get.arguments['order'];
    }
  }

  Future<void> updateCustAddress(
      String orderId, String newAddress, double custLat, double custLng) async {
    try {
      isLoading.value = true;

      ApiResponse<Order> response = await orderRepository.updateCustAddress(
          orderId, newAddress, custLat, custLng);

      if (response.status == Status.OK) {
        order.value = response.data;
        Loaders.successSnackBar(
          title: "Thành công",
          message: "Thay đổi địa chỉ giao hàng thành công!",
        );
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại",
          message:
              "Thay đổi địa chỉ giao hàng không thành công. Vui lòng thử lại!",
        );
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> calculateDeliveryFee(Order updatedOrder) async {
    try {
      isLoading.value = true;
      final responseData = await orderRepository.calcDeliveryFee(
        customerLat: updatedOrder.custLat ?? 0,
        customerLng: updatedOrder.custLng ?? 0,
        restaurantId: updatedOrder.restaurantId,
      );

      if (responseData.data != null) {
        final newDeliveryFee =
            (responseData.data?["deliveryFee"] as num?)?.toInt() ?? 0;
        final distance = responseData.data?["distance"];

        if (distance == null) {
          order.value = order.value?.copyWith(deliveryFee: 0);
        } else {
          order.value = order.value?.copyWith(deliveryFee: newDeliveryFee);
        }
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
