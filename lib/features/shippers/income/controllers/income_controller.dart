import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/driver/driver_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/income/controllers/date_range_controller.dart';
import 'package:food_delivery_h2d/features/shippers/income/models/income_model.dart';
import 'package:get/get.dart';

class IncomeController extends GetxController {
  static IncomeController get instance => Get.find();
  var selectedFilter = 0.obs;
  var value = 0.0.obs;
  var count = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final _repository = DriverRepository();
  RxList<IncomeModel> incomeData = <IncomeModel>[].obs;

  var touchedIndex = Rx<int>(-1);
  final dateRangeController = Get.put(DriverDateRangeController());

  void updateTouchedIndex(int index) {
    touchedIndex.value = index;
  }

  @override
  void onInit() async {
    fetchIncome();
    super.onInit();
  }

  int get totalIncome => incomeData
      .where((item) => item.status == 'completed')
      .fold(0, (sum, item) => sum + item.deliveryFee);

  int get totalOrders => incomeData.length;

  int get totalCompletedOrders =>
      incomeData.where((item) => item.status == 'completed').length;

  int get totalFailedOrders =>
      incomeData.where((item) => item.status == 'cancelled').length;

  int get totalDelivering =>
      incomeData.length -
      (incomeData.where((item) => item.status == 'completed').length +
          incomeData.where((item) => item.status == 'cancelled').length);
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

      incomeData.value = await _repository.fetchIncomeDriver(
          LoginController.instance.currentUser.driverId,
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

      // final dateFrom =
      //     dateRangeController.dateRange.value.start.toIso8601String();
      // final dateTo = DateTime(dateRangeController.dateRange.value.end.year, dateRangeController.dateRange.value.end.month, dateRangeController.dateRange.value.end.day, 23, 59, 59)
      //   .toIso8601String();
      final dateFrom =
          dateRangeController.dateRange.value.start.toIso8601String();
      final dateTo = DateTime(
              dateRangeController.dateRange.value.end.year,
              dateRangeController.dateRange.value.end.month,
              dateRangeController.dateRange.value.end.day,
              23,
              59,
              59)
          .toIso8601String();

      incomeData.value = await _repository.fetchIncomeDriver(
          LoginController.instance.currentUser.driverId,
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
