import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/date_range_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/statistic_model.dart';
import 'package:get/get.dart';

class IncomeHomeController extends GetxController {
  static IncomeHomeController get instance => Get.find();
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
    await fetchIncomeFromStartDay();
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

  //Tính thu nhập từ ngày tham gia đến bây giờ
  Future<void> fetchIncomeFromStartDay() async {
    try {
      isLoading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = 'No internet connection';
        return;
      }

      final dateFrom =
          LoginController.instance.currentUser.createdAt.toIso8601String();
      final dateTo = DateTime.now().toIso8601String();

      incomeData.value = await _repository.fetchStatistic(
          LoginController.instance.currentUser.partnerId,
          dateFrom: "$dateFrom",
          dateTo: dateTo);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Error fetching data: ${e.toString()}';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
