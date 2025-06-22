import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_restaurant_model.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';

class TopRestaurantController extends GetxController {
  static TopRestaurantController get instance => Get.find();

  List<Item> allItems = <Item>[].obs;
  var errorMessagePartner = ''.obs;

  var isLoading = false.obs;
  var value = 0.0.obs;
  var errorMessage = ''.obs;
  var topRestaurantList = <TopRestaurantModel>[].obs;

  final PartnerRepository _repository = Get.put(PartnerRepository());
  String userId = '';


  @override
  void onInit() async {
    await fetchTopRestaurant();

    super.onInit();
  }


  Future<void> fetchTopRestaurant() async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final data = await _repository.fetchTopRestaurant();

      topRestaurantList.value = data;
    } catch (e) {
      errorMessage.value =
          "Error fetching top restaurant details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }
}
