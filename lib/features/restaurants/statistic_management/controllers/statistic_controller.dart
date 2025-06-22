import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/date_range_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/statistic_model.dart';
import 'package:get/get.dart';

class StatisticController extends GetxController {
  static StatisticController get instance => Get.find();
  var selectedFilter = 0.obs;
  var value = 0.0.obs;
  var count = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final _repository = PartnerRepository();
  RxList<StatisticModel> incomeData = <StatisticModel>[].obs;

  var touchedIndex = Rx<int>(-1);
  final restaurantDateRangeController =
      Get.put(RestaurantDateRangeController());

  void updateTouchedIndex(int index) {
    touchedIndex.value = index;
  }

  @override
  void onInit() async {
    await fetchIncome();
    super.onInit();
  }

  // Tổng thu nhập chỉ tính những đơn có status là 'completed'
  int get totalIncome => incomeData
      .where((item) => item.status == 'completed')
      .fold(0, (sum, item) => sum + item.totalPrice);

  int get totalOrders => incomeData.length;

  int get totalCompletedOrders =>
      incomeData.where((item) => item.status == 'completed').length;

  int get totalFailedOrders =>
      incomeData.where((item) => item.status == 'cancelled').length;
int get totalDelivering =>
      incomeData.length -
      (incomeData.where((item) => item.status == 'completed').length +
          incomeData.where((item) => item.status == 'cancelled').length);
  // Fetch dữ liệu thu nhập mặc định (không có bộ lọc)
  Future<void> fetchIncome() async {
    try {
      isLoading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = 'No internet connection';
        return;
      }

      final dateFrom = DateTime(DateTime.now().year, 1, 1).toIso8601String();
      final dateTo = DateTime.now().toIso8601String();

      incomeData.value = await _repository.fetchStatistic(
          LoginController.instance.currentUser.partnerId,
          dateFrom: dateFrom,
          dateTo: dateTo);

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Error fetching data: ${e.toString()}';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch dữ liệu thu nhập với bộ lọc thời gian
  Future<void> fetchFilterIncome() async {
    try {
      isLoading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = 'No internet connection';
        return;
      }

      final dateFrom =
          restaurantDateRangeController.dateRange.value.start.toIso8601String();
      final dateTo = DateTime(
              restaurantDateRangeController.dateRange.value.end.year,
              restaurantDateRangeController.dateRange.value.end.month,
              restaurantDateRangeController.dateRange.value.end.day,
              23,
              59,
              59)
          .toIso8601String();

      incomeData.value = await _repository.fetchStatistic(
          LoginController.instance.currentUser.partnerId,
          dateFrom: "${dateFrom}Z",
          dateTo: "${dateTo}Z");
      errorMessage.value = '';
    } catch (e) {
      print("errrroror ${e}");
      errorMessage.value = 'Error fetching data: ${e.toString()}';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
