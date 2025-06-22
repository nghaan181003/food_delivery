import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/user/user_repository.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/models/chart_model.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserManagementController extends GetxController {
  static UserManagementController get instance => Get.find();
  var userList = <UserModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var touchedIndex = (-1).obs;
  final UserRepository _repository = UserRepository();
  var roleCounts = <String, int>{}.obs;
  var selectedMonth = ''.obs; 

  final DateFormat monthFormat = DateFormat('yyyy-MM');
  @override
  void onInit() {
    fetchAllUsers();
    super.onInit();
  }

  void fetchAllUsers() async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }
      final data = await _repository.fetchAllUsers();
      userList.value = data;
      if (selectedMonth.value.isEmpty) {
        selectedMonth.value = monthFormat.format(DateTime.now());
      }
      updateRoleCounts();
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void updateRoleCounts() {
    final Map<String, int> counts = {};
    for (var user in userList) {
      final role = user.role;
      counts[role] = (counts[role] ?? 0) + 1;
    }
    roleCounts.value = counts;
  }

  List<ChartModel> getPieChartData() {
    final totalUsers = roleCounts.values.fold(0, (sum, count) => sum + count);
    return roleCounts.entries
        .map((entry) => ChartModel(
              xData: entry.key,
              count: entry.value,
              yData: ((entry.value / totalUsers) * 100).toStringAsFixed(1),
            ))
        .toList();
  }

  void updateTouchedIndex(int index) {
    touchedIndex.value = index;
  }

  List<String> getAvailableMonths() {
    final months = userList
        .map((user) {
          return DateFormat('yyyy-MM').format(user.createdAt);
        })
        .toSet()
        .toList();
    months.sort();
    return months;
  }

  List<ChartModel> getFilteredChartData() {
    if (selectedMonth.value.isEmpty) {
      return [];
    }

    final filteredUsers = userList.where((user) {
      final userMonth = DateFormat('yyyy-MM').format(user.createdAt);
      return userMonth == selectedMonth.value;
    });

    final Map<String, int> dailyCounts = {};
    for (var user in filteredUsers) {
      final day = DateFormat('dd').format(user.createdAt);
      dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
    }

    return List.generate(31, (index) {
      final day = (index + 1).toString().padLeft(2, '0');
      return ChartModel(
        xData: day,
        count: dailyCounts[day] ?? 0,
        yData: '',
      );
    });
  }
}
