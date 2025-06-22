import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/authentication/models/ProvinceModel.dart';
import 'package:food_delivery_h2d/features/authentication/models/DistrictModel.dart';
import 'package:food_delivery_h2d/features/authentication/models/CommuneModel.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  var provinces = <ProvinceModel>[].obs;
  var districts = <DistrictModel>[].obs;
  var communes = <CommuneModel>[].obs;

  var selectedProvince = "".obs;
  var selectedDistrict = "".obs;
  var selectedCommune = "".obs;

  final _addressRepository = Get.put(AddressRepository());

  @override
  void onClose() {
    provinces.clear();
    districts.clear();
    communes.clear();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProvinces();
  }

  Future<void> fetchProvinces() async {
    try {
      var provinceList = await _addressRepository.getProvinces();
      provinces.assignAll(provinceList);
      // print("Dữ liệu các tỉnh: $provinces");
    } catch (e) {
      print("Error fetching provinces: $e");
    }
  }

  Future<void> fetchDistricts(String provinceId) async {
    try {
      var districtList = await _addressRepository.getDistrict(provinceId);
      districts.assignAll(districtList);
    } catch (e) {
      print("Error fetching districts: $e");
    }
  }

  Future<void> fetchCommunes(String districtId) async {
    try {
      var communeList = await _addressRepository.getCommunes(districtId);
      communes.assignAll(communeList);
    } catch (e) {
      print("Error fetching communes: $e");
    }
  }

  Future<String> getFullAddress(String? provinceId, String? districtId,
      String? communeId, String? detailAddress) async {
    try {
      var province = await _addressRepository.getProvinceById(provinceId ?? "");

      if (districtId != null && districtId.isNotEmpty) {
        var districtList = await _addressRepository.getDistrict(provinceId!);
        var district =
            districtList.firstWhere((d) => d.id == districtId).fullName;

        if (communeId != null && communeId.isNotEmpty) {
          var communeList = await _addressRepository.getCommunes(districtId);
          var commune =
              communeList.firstWhere((c) => c.id == communeId).fullName;

          return "$detailAddress, $commune, $district, ${province.fullName}";
        } else {
          return "$detailAddress, $district, ${province.fullName}";
        }
      } else {
        return "$detailAddress, ${province.fullName}";
      }
    } catch (e) {
      return "Error fetching address";
    }
  }
}
