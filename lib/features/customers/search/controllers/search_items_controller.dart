import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/features/customers/search/models/item_model.dart';
import 'package:get/get.dart';

class SearchItemsController extends GetxController {
  var itemSearchList = <ItemModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var isSearchCompleted = false.obs; 
  final ItemRepository _repository = ItemRepository();


  void fetchItemSearch(String query) async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = 'No internet connection';
        return;
      }
      final data = await _repository.searchItems(query);
      itemSearchList.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading(false);
      isSearchCompleted(true); 
    }
  }
}
