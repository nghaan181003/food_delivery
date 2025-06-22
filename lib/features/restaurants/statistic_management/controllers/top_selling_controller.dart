import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/top_selling.dart';
import 'package:get/get.dart';

class TopSellingController extends GetxController {
  var list = <TopSellingItem>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var showCanXuLy = true.obs;

  final _repository = Get.put(ItemRepository());

  @override
  void onInit() {
    super.onInit();
    getListSelling();
  }

  void getListSelling() async {
    try {
      isLoading(true);
      final data = await _repository.getTopSelling(LoginController.instance.currentUser.partnerId);
      list.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
