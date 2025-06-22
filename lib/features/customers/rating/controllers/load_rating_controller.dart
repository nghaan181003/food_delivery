import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:get/get.dart';

class LoadRatingController extends GetxController {
  static LoadRatingController get instance => Get.find();

  var isLoading = true.obs;
  var order = Rxn<Order>(); // Dữ liệu đơn hàng, khởi tạo null
  final orderRepository = Get.put(OrderRepository());

  Future<void> fetchOrderById(String orderId) async {
    try {
      isLoading(true);
      final response = await orderRepository.getOrderById(orderId);
      order.value = response.data;
    } catch (e) {
      print("Error fetching order: $e");
    } finally {
      isLoading(false);
    }
  }
}
