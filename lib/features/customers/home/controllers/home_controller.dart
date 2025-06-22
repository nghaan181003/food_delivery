import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/helpers/location.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var itemSearchList = <Item>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final ItemRepository _repository = ItemRepository();

  void fetchItemSearch(String query) async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = 'No internet connection';
        return;
      }
      final data = await _repository.searchItemInHome(query);
      itemSearchList.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final address =
          await LocationHelper.getAddressFromCoordinates(latitude, longitude);
      if (address != null) {
        return address;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
    return null;
  }
}
