import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  static RatingController get instance => Get.find();
  var selectedFilter = 0.obs;
  var value = 0.0.obs;
  var count = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final _repository = PartnerRepository();
  var ratingList = <RatingModel>[].obs;

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
      data.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
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

  double get oneStarPercent {
    if (ratingList.isEmpty) return 0.0;
    int oneStarCount =
        ratingList.where((rating) => rating.custResRating == 1).length;
    return oneStarCount / ratingList.length;
  }

  double get twoStarPercent {
    if (ratingList.isEmpty) return 0.0;
    int twoStarCount =
        ratingList.where((rating) => rating.custResRating == 2).length;
    return twoStarCount / ratingList.length;
  }

  double get threeStarPercent {
    if (ratingList.isEmpty) return 0.0;
    int threeStarCount =
        ratingList.where((rating) => rating.custResRating == 3).length;
    return threeStarCount / ratingList.length;
  }

  double get fourStarPercent {
    if (ratingList.isEmpty) return 0.0;
    int fourStarCount =
        ratingList.where((rating) => rating.custResRating == 4).length;
    return fourStarCount / ratingList.length;
  }

  double get fiveStarPercent {
    if (ratingList.isEmpty) return 0.0;
    int fiveStarCount =
        ratingList.where((rating) => rating.custResRating == 5).length;
    return fiveStarCount / ratingList.length;
  }
}
