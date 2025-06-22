import 'package:food_delivery_h2d/data/user/user_repository.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  var userList = <UserModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final UserRepository _repository = UserRepository();
  int page = 1;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUserInAdmin();
  }

  Future<void> fetchAllUserInAdmin({bool loadMore = false}) async {
    isLoading.value = true;

    if (loadMore) {
      page++;
    }

    try {
      final fetched = await _repository.fetchAllUsersInAdmin(page: page);
      final newOrders = (fetched.data as List<UserModel>);
      userList.assignAll(newOrders);
      hasMore.value = newOrders.isNotEmpty;
    } catch (e) {
      errorMessage.value = "Lỗi khi tải người dùng: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void previousPage() {
    if (page > 1) {
      page--;
      fetchAllUserInAdmin();
    }
  }
}
