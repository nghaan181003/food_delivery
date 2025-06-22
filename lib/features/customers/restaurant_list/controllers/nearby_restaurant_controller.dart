import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_restaurant_model.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';

class NearbyRestaurantController extends GetxController {
  static NearbyRestaurantController get instance => Get.find();

  List<Item> allItems = <Item>[].obs;
  var errorMessagePartner = ''.obs;

  var isLoading = false.obs;
  var value = 0.0.obs;
  var errorMessage = ''.obs;
  var restaurantList = <TopRestaurantModel>[].obs;

  final PartnerRepository _repository = Get.put(PartnerRepository());
  String userId = '';

  @override
  void onInit() async {
    final location = LoginController.instance.currentLocation;
    await fetchNearbyRestaurant(
        location['latitude'], location['longitude'], 20, 20);

    super.onInit();
  }

  Future<void> fetchNearbyRestaurant(
      double latitude, double longitude, int maxDistance, int limit) async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }
      debugPrint("Fetching nearby restaurant with latitude: $latitude");
      final data = await _repository.fetchNearbyRestaurant(
          latitude: latitude,
          longitude: longitude,
          maxDistance: maxDistance,
          limit: limit);
      debugPrint("Nearby restaurant data: $data");
      restaurantList.value = data;
    } catch (e) {
      errorMessage.value =
          "Error fetching top restaurant details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }
}
