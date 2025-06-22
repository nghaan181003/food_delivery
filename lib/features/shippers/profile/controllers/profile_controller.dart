import 'package:food_delivery_h2d/data/driver/driver_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/utils/helpers/location.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final currentUser = LoginController.instance.currentUser;
  final OrderController orderController = Get.find();
  var isWorking = false.obs;
  final RxInt addressKey = RxInt(0);

  @override
  onInit() {
    super.onInit();

    isWorking.value = LoginController.instance.currentUser.workingStatus;
  }

  Future<void> toggleWorkingStatus() async {
    final invalidOrders = orderController.orders.where((order) =>
        order.driverStatus != 'delivered' && order.driverStatus != 'cancelled');

    if (invalidOrders.isNotEmpty) {
      Loaders.errorSnackBar(
        title: "Không thể tắt trạng thái hoạt động",
        message: "Bạn đang có đơn hàng chưa hoàn thành.",
      );
      return;
    }
    if (currentUser == null || currentUser.driverId == null) {
      return;
    }

    final newStatus = !isWorking.value;
    isWorking.value = newStatus;

    try {
      await DriverRepository.instance
          .updateDriverStatus(currentUser.driverId, newStatus);

      currentUser.workingStatus = newStatus;
      if (currentUser.workingStatus) {
        Loaders.successSnackBar(
            title: "Thành công", message: "Đã bật trạng thái hoạt động.");
      } else {
        Loaders.successSnackBar(
            title: "Thành công", message: "Đã tắt trạng thái hoạt động.");
      }
    } catch (error) {
      isWorking.value = !newStatus;
      Get.snackbar(
        "Error",
        "Failed to update working status. Please check your network and try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final address =
          await LocationHelper.getAddressFromCoordinates(latitude, longitude);
      if (address != null) {
        return address;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
    return null;
  }
}
