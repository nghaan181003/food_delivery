import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_item_model.dart';
import 'package:get/get.dart';

class TopItemController extends GetxController {
  static TopItemController get instance => Get.find();

  var errorMessagePartner = ''.obs;

  var isLoading = false.obs;
  var value = 0.0.obs;
  var errorMessage = ''.obs;
  var topItemList = <TopItemModel>[].obs;

  final _repository = Get.put(ItemRepository());
  String userId = '';


  @override
  void onInit() async {
    await fetchTopItems();

    super.onInit();
  }


  Future<void> fetchTopItems() async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final data = await _repository.fetchTopItems();

      topItemList.value = data;
    } catch (e) {
      errorMessage.value =
          "Error fetching top restaurant details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }
}
