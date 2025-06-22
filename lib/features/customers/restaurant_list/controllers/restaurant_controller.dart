import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/category/category_repository.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/detail_partner_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_restaurant_model.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';

class RestaurantController extends GetxController {
  static RestaurantController get instance => Get.find();

  List<Item> allItems = <Item>[].obs;
  var errorMessagePartner = ''.obs;

  var isLoading = false.obs;
  List<Category> allCategories = <Category>[].obs;
  var detailPartner = Rxn<DetailPartnerModel>();
  var selectedFilter = 0.obs;
  var value = 0.0.obs;
  var count = 0.obs;
  var errorMessage = ''.obs;
  var ratingList = <RatingModel>[].obs;
  var topRestaurantList = <TopRestaurantModel>[].obs;

  final CategoryRepository _categoryRepository = Get.put(CategoryRepository());
  final ItemRepository _itemRepository = Get.put(ItemRepository());
  final PartnerRepository _repository = Get.put(PartnerRepository());
  String userId = '';

  // * Topping state
  final List<ToppingGroupModel> toppings = [];

  void setUserId(String id) {
    userId = id;
  }

  @override
  void onInit() async {
    await fetchTopRestaurant();
    super.onInit();
  }

  Future<void> fetchCategoriesAndItems() async {
    try {
      isLoading.value = true;
      allCategories.assignAll(
          await _categoryRepository.getCategoriesInRestaurant(userId));
      await fetchAllItems();
    } catch (e) {
      print("Lỗi khi lấy danh mục và món ăn: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllItems() async {
    try {
      final allItemsByCategory = await Future.wait(
        allCategories.map((cat) async => await _itemRepository
            .getItemsByCategoryIDInCustomer(cat.categoryId)),
      );
      final combinedItems =
          allItemsByCategory.expand((items) => items).toList();
      allItems.assignAll(combinedItems);
    } catch (error) {
      print("Lỗi khi lấy món ăn: $error");
    }
  }

  List<Item> getItemsForCategory(String categoryId) {
    return allItems.where((item) => item.categoryId == categoryId).toList();
  }

  Future<void> fetchDetailPartner(String partnerId) async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessagePartner.value = "No internet connection";
        return;
      }
      final partnerResponse =
          await _repository.getPartnerByPartnerId(partnerId);
      detailPartner.value = partnerResponse;
    } catch (e) {
      print("Error: ${e.toString()}");

      errorMessagePartner.value =
          "Error fetching partner details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchRating(String id) async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final data = await _repository.fetchPartnerRating(id);

      print("id user$id");
      ratingList.value = data;
      await calculateAverageRating();
      await countComments();
    } catch (e) {
      errorMessage.value = "Error fetching driver details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<void> calculateAverageRating() async {
    if (ratingList.isNotEmpty) {
      double totalStars =
          ratingList.fold(0, (sum, rating) => sum + rating.custResRating);
      value.value = totalStars / ratingList.length;
    } else {
      value.value = 0.0;
    }
  }

  Future<void> countComments() async {
    count.value = ratingList.length;
  }

  List<RatingModel> get filteredRatings {
    if (selectedFilter.value == 0) {
      return ratingList;
    }
    return ratingList
        .where((rating) => rating.custResRating == selectedFilter.value)
        .toList();
  }

  void updateFilter(int newFilter) {
    selectedFilter.value = newFilter;
    print("Updated selectedFilter: ${selectedFilter.value}"); // Log giá trị mới
    print(
        "Filtered ratings count: ${filteredRatings.length}"); // Log số lượng đánh giá đã lọc
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
      await calculateAverageRating();
      await countComments();
    } catch (e) {
      errorMessage.value =
          "Error fetching top restaurant details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<bool> getToppings(String productId) async {
    try {
      final result = await _itemRepository.getToppingsByProductIdForCustomer(
          id: productId);
      if (result.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: result.message);
        return false;
      }
      toppings.assignAll(result.data);
      return toppings.isNotEmpty;
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      return false;
    }
  }
}
