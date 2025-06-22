import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/models/order_status_chart.dart';
import 'package:get/get.dart';

class OrderStatusChartController extends GetxController {
  static OrderStatusChartController get instance => Get.find();
  var selectedFilter = 0.obs;
  var value = 0.0.obs;
  var count = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final _repository = OrderRepository();
  var incomeData = Rx<OrderStatusChartModel?>(null);
  var touchedIndex = Rx<int>(-1);

  void updateTouchedIndex(int index) {
    touchedIndex.value = index;
  }

  @override
  void onInit() async {
    await fetchIncome();
    super.onInit();
  }

  Future<void> fetchIncome() async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final data = await _repository.fetchStatistic();
      incomeData.value = data;
    } catch (e) {
      errorMessage.value = "Error fetching driver details: ${e.toString()}";
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
