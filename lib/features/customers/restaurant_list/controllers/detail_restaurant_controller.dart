import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/detail_partner_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_restaurant_model.dart';
import 'package:get/get.dart';

class DetailRestaurantController extends GetxController {
  static DetailRestaurantController get instance => Get.find();

  var errorMessagePartner = ''.obs;
  var isLoading = false.obs;
  var restaurants = <TopRestaurantModel>[].obs;
  var detailPartner = Rxn<DetailPartnerModel>();

  // Use Rx to handle nullable variables
  var provinceName = Rx<String?>(null);
  var districtName = Rx<String?>(null);
  var communeName = Rx<String?>(null);

  final PartnerRepository _repository = Get.put(PartnerRepository());
  final _addressRepository = Get.put(AddressRepository());
  String userId = '';

  void setUserId(String id) {
    userId = id;
  }

  // Address getter that handles null values
  String get address {
    if (provinceName.value == null ||
        districtName.value == null ||
        communeName.value == null) {
      return "Đang tải...";
    }
    return "${detailPartner.value?.detailAddress}, ${communeName.value}, ${districtName.value}, ${provinceName.value}";
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
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

  void fetchDetailPartner(String partnerId) async {
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
      fetchData();
      print(
          "Controller received partnerResponse: ${partnerResponse.toString()}");
    } catch (e) {
      print("Error: ${e.toString()}");
      errorMessagePartner.value =
          "Error fetching partner details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchProvinceName() async {
    try {
      final provinces = await _addressRepository.getProvinces();
      provinceName.value = provinces
          .firstWhere(
              (province) => province.id == detailPartner.value?.provinceId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchDistrictName() async {
    try {
      final districts =
          await _addressRepository.getDistrict(detailPartner.value!.provinceId);
      districtName.value = districts
          .firstWhere(
              (district) => district.id == detailPartner.value?.districtId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchCommunes() async {
    try {
      final communes =
          await _addressRepository.getCommunes(detailPartner.value!.districtId);
      communeName.value = communes
          .firstWhere((commune) => commune.id == detailPartner.value?.communeId)
          .fullName;
    } catch (e) {
      print(e);
    }
  }
}
