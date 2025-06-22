import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/models/profile_restaurant_model.dart';

class ProfileRestaurantController extends GetxController {
  static ProfileRestaurantController get instance => Get.find();
  final _addressRepository = Get.put(AddressRepository());
  final currentUser = LoginController.instance.currentUser;

  var profile = ProfileRestaurant(); // Khởi tạo ProfileRestaurant theo nhu cầu
  Future<void> refreshProfile() async {
    await LoginController.instance.refreshCurrentUser();
    await fetchData();
    profile.isAvailable.value =
        LoginController.instance.currentUser.workingStatus;
  }

  Future<void> toggleItemAvailability(ProfileRestaurant profile) async {
    final newStatus = !profile.isAvailable.value;
    profile.isAvailable.value = newStatus;

    try {
      await PartnerRepository.instance
          .updatePartnerStatus(currentUser.partnerId, newStatus);

      currentUser.workingStatus = newStatus;
      if (currentUser.workingStatus) {
        Loaders.successSnackBar(
            title: "Thành công", message: "Đã bật trạng thái hoạt động.");
      } else {
        Loaders.successSnackBar(
            title: "Thành công", message: "Đã tắt trạng thái hoạt động.");
      }
    } catch (error) {
      profile.isAvailable.value = !newStatus;
      Get.snackbar(
        "Error",
        "Failed to update working status. Please check your network and try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  var isLoading = false.obs;
  late String provinceName;
  late String districtName;
  late String communeName;

  @override
  void onInit() {
    fetchData();

    profile = ProfileRestaurant();
    profile.isAvailable.value =
        LoginController.instance.currentUser.workingStatus;
    print(
        "status hien taji ${LoginController.instance.currentUser.workingStatus}");

    super.onInit();
  }

  String get address {
    return "${LoginController.instance.currentUser.detailAddress}, $communeName, $districtName, $provinceName";
  }

  Future fetchData() async {
    try {
      isLoading.value = true;
      await _fetchProvinceName();
      await _fetchDistrictName();
      await _fetchCommunes();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchProvinceName() async {
    try {
      final provinces = await _addressRepository.getProvinces();
      provinceName = provinces
          .firstWhere((province) =>
              province.id == LoginController.instance.currentUser.provinceId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchDistrictName() async {
    try {
      final districts = await _addressRepository
          .getDistrict(LoginController.instance.currentUser.provinceId);
      districtName = districts
          .firstWhere((district) =>
              district.id == LoginController.instance.currentUser.districtId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchCommunes() async {
    try {
      final communes = await _addressRepository
          .getCommunes(LoginController.instance.currentUser.districtId);

      communeName = communes
          .firstWhere((commune) =>
              commune.id == LoginController.instance.currentUser.communeId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }
}
