import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_item_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class FavoriteListController extends GetxController {
  static FavoriteListController get instance => Get.find();

  var errorMessagePartner = ''.obs;

  var isLoading = false.obs;
  var value = 0.0.obs;
  var errorMessage = ''.obs;
  var favoriteList = <TopItemModel>[].obs;

  final _repository = Get.put(ItemRepository());
  String userId = '';

  @override
  void onInit() async {
    await fetchFavoriteList();

    super.onInit();
  }

  Future<void> fetchFavoriteList() async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final data = await _repository
          .fetchFavoriteList(LoginController.instance.currentUser.userId);

      favoriteList.value = data;
    } catch (e) {
      errorMessage.value = "Error fetching favorite list: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToFavorites(String itemId) async {
    try {
      isLoading(true);
      await _repository.addFavoriteItem(
          LoginController.instance.currentUser.userId, itemId);
      await fetchFavoriteList();
      Loaders.successSnackBar(
          title: "Thành công",
          message: "Đã thêm món ăn vào danh sách yêu thích");
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
      errorMessage.value = "Error adding to favorite list: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeFromFavorites(String itemId) async {
    try {
      isLoading(true);
      await _repository.deleteFavoriteItem(
          LoginController.instance.currentUser.userId, itemId);
      favoriteList.removeWhere((item) => item.id == itemId);
      Loaders.successSnackBar(
          title: "Thành công",
          message: "Đã xoá món ăn ra khỏi danh sách yêu thích");
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
      errorMessage.value = "Error removing from favorite list: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }
}
