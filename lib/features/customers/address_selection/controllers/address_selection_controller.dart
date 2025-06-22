import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/follow_order_controller.dart';
import 'package:food_delivery_h2d/services/location_service.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class AddressSelectionController extends GetxController {
  static AddressSelectionController get instance => Get.find();

  var provinces = [].obs;
  var districts = [].obs;
  var communes = [].obs;

  var selectedProvinceId = '79'.obs;
  var selectedDistrictId = ''.obs;
  var selectedCommuneId = ''.obs;
  var fullAddress = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isSelectAddress = true;

  TextEditingController detailAddressController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController communeController = TextEditingController();
  var lengthDetailAddress = 0.obs;

  final AddressRepository _addressRepository = AddressRepository();

  // Giới hạn địa lý TP.HCM (bao gồm TP Thủ Đức)
  final hcmBounds = LatLngBounds(
    const LatLng(10.65, 106.55), // Tây Bắc (gần Tân Bình)
    const LatLng(10.90, 106.90), // Đông Nam (bao gồm Long Thạnh Mỹ, TP Thủ Đức)
  );

  @override
  void onInit() {
    super.onInit();
    detailAddressController = TextEditingController();
    districtController = TextEditingController();
    communeController = TextEditingController();
    selectedDistrictId.value = '';
    selectedCommuneId.value = '';
    fullAddress.value = '';
    latitude.value = 0.0;
    longitude.value = 0.0;
    districts.clear();
    communes.clear();
    lengthDetailAddress.value = 0;
    fetchDistricts('79');
  }

  @override
  void onClose() {
    // detailAddressController.dispose();
    // districtController.dispose();
    // communeController.dispose();
    super.onClose();
  }

  Future<LatLng> getInitialPositionForMap() async {
    print("selectedDistrictId.value: ${selectedDistrictId.value}");
    try {
      // Nếu đã chọn quận/huyện
      if (selectedDistrictId.value.isNotEmpty) {
        final district = districts.firstWhere(
          (district) => district.id == selectedDistrictId.value,
          orElse: () => null,
        );
        if (district != null) {
          return LatLng(
            double.parse(district.latitude),
            double.parse(district.longitude),
          );
        }
      }
      // Nếu chưa chọn quận/huyện, lấy vị trí hiện tại
      final position = await LocationService.getLocation();
      if (position != null) {
        return LatLng(position.latitude, position.longitude);
      }
      // Fallback về trung tâm TP.HCM
      return const LatLng(10.7769, 106.7009);
    } catch (e) {
      return const LatLng(10.7769, 106.7009);
    }
  }

  Future<void> fetchDistricts(String idProvince) async {
    try {
      districts.assignAll(await _addressRepository.getDistrict(idProvince));
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách quận/huyện.");
    }
  }

  Future<void> fetchCommunes(String idDistrict) async {
    try {
      communes.assignAll(await _addressRepository.getCommunes(idDistrict));
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách phường/xã.");
    }
  }

  void updateSelectedDistrictId(String districtId) {
    selectedDistrictId.value = districtId;
    selectedCommuneId.value = '';
    detailAddressController.text = '';
    fetchCommunes(districtId);
    updateFullAddress();
  }

  void updateSelectedCommuneId(String communeId) {
    selectedCommuneId.value = communeId;
    detailAddressController.text = '';
    lengthDetailAddress.value = 0;
    updateFullAddress();
  }

  void handleDetailAddressChange(String value) {
    lengthDetailAddress.value = value.length;
    updateFullAddress();
  }

  void updateFullAddress() {
    if (selectedDistrictId.value.isEmpty || selectedCommuneId.value.isEmpty) {
      fullAddress.value = '';
      return;
    }

    String provinceName = "Thành phố Hồ Chí Minh";
    String districtName = districts.isNotEmpty
        ? districts
                .firstWhere(
                  (district) => district.id == selectedDistrictId.value,
                  orElse: () => null,
                )
                ?.fullName ??
            districtController.text
        : districtController.text;
    String communeName = communes.isNotEmpty
        ? communes
                .firstWhere(
                  (commune) => commune.id == selectedCommuneId.value,
                  orElse: () => null,
                )
                ?.fullName ??
            communeController.text
        : communeController.text;

    fullAddress.value =
        '${detailAddressController.text}, $communeName, $districtName, $provinceName';
  }

  Future<bool> _isWithinHCM(double lat, double lon) async {
    if (!hcmBounds.contains(LatLng(lat, lon))) {
      return false;
    }

    const String locationIqApiKey = "pk.830e389b41abcec44116a981f89c54d4";
    final String url =
        "https://us1.locationiq.com/v1/reverse.php?key=$locationIqApiKey&lat=$lat&lon=$lon&format=json&accept-language=vi";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        String? state = data["address"]["state"];
        String? city = data["address"]["city"];
        String? county = data["address"]["county"];
        String? countryCode = data["address"]["country_code"];

        if (countryCode != "vn") {
          return false;
        }

        String hcmName =
            removeDiacritics("Thành phố Hồ Chí Minh").toLowerCase();
        String thuDucName = removeDiacritics("Thành phố Thủ Đức").toLowerCase();

        bool isHCM = (state != null &&
                removeDiacritics(state).toLowerCase() == hcmName) ||
            (city != null &&
                (removeDiacritics(city).toLowerCase() == hcmName ||
                    removeDiacritics(city).toLowerCase() == thuDucName)) ||
            (county != null &&
                (removeDiacritics(county).toLowerCase() == hcmName ||
                    removeDiacritics(county).toLowerCase() == thuDucName));

        if (!isHCM) {}
        return isHCM;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateLocationFromMap(double lat, double lon) async {
    try {
      bool isHCM = await _isWithinHCM(lat, lon);
      if (!isHCM) {
        latitude.value = 0.0;
        longitude.value = 0.0;
        Loaders.errorSnackBar(
          title: "Lỗi",
          message:
              "Địa chỉ được chọn không thuộc Thành phố Hồ Chí Minh. Vui lòng chọn vị trí trong TP.HCM.",
        );
        return;
      }

      latitude.value = lat;
      longitude.value = lon;
      await updateLocation(lat, lon);
    } catch (e) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: "Không thể cập nhật vị trí: $e",
      );
      latitude.value = 0.0;
      longitude.value = 0.0;
    }
  }

  Future<void> confirmAddress({
    required bool isUpdate,
    String? orderId,
  }) async {
    if (selectedDistrictId.value.isEmpty || selectedCommuneId.value.isEmpty) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: "Vui lòng chọn quận/huyện và phường/xã.",
      );
      return;
    }

    if (detailAddressController.text.trim().isEmpty) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: "Vui lòng nhập địa chỉ chi tiết.",
      );
      return;
    }

    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message:
            "Vui lòng chọn vị trí trên bản đồ hoặc sử dụng vị trí hiện tại.",
      );
      return;
    }

    bool isHCM = await _isWithinHCM(latitude.value, longitude.value);
    if (!isHCM) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message:
            "Địa chỉ được chọn không thuộc Thành phố Hồ Chí Minh. Vui lòng chọn vị trí trong TP.HCM.",
      );
      return;
    }

    String newAddress = fullAddress.value;
    if (newAddress.isEmpty) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: "Địa chỉ không hợp lệ. Vui lòng kiểm tra lại.",
      );
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    try {
      final addressData = {
        'fullAddress': newAddress,
        'latitude': latitude.value,
        'longitude': longitude.value,
      };
      debugPrint("addressData: $addressData");

      if (isUpdate) {
        // var controller = Get.put(FollowOrderController());
        // await controller.updateCustAddress(orderId!, newAddress);
      } else {
        OrderController.instance.order
          ..custAddress = newAddress
          ..custLatitude = latitude.value
          ..custLongitude = longitude.value;
      }

      Get.back();
      Get.back(result: addressData);
    } catch (e) {
      Get.back();
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> fetchCoordinatesFromAddress(String address) async {
    const String locationIqApiKey = "pk.830e389b41abcec44116a981f89c54d4";
    final String encodedAddress = Uri.encodeComponent(address);
    final String url =
        "https://us1.locationiq.com/v1/search.php?key=$locationIqApiKey&q=$encodedAddress&format=json&accept-language=vi";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final result = data[0];
          double lat = double.parse(result['lat']);
          double lon = double.parse(result['lon']);
          bool isHCM = await _isWithinHCM(lat, lon);
          if (!isHCM) {
            throw Exception(
                'Địa chỉ được nhập không thuộc Thành phố Hồ Chí Minh.');
          }
          latitude.value = lat;
          longitude.value = lon;
        } else {
          throw Exception('Không tìm thấy tọa độ cho địa chỉ này.');
        }
      } else {
        throw Exception(
            'Không thể lấy tọa độ. Mã trạng thái: ${response.statusCode}');
      }
    } catch (e) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> updateLocation(double lat, double lon) async {
    const String locationIqApiKey = "pk.830e389b41abcec44116a981f89c54d4";
    final String url =
        "https://us1.locationiq.com/v1/reverse.php?key=$locationIqApiKey&lat=$lat&lon=$lon&format=json&accept-language=vi";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("🔍 Địa chỉ: $data");

        String? state = data["address"]["state"];
        String? city = data["address"]["city"];
        String? county = data["address"]["county"];
        String? countryCode = data["address"]["country_code"];
        String hcmName =
            removeDiacritics("Thành phố Hồ Chí Minh").toLowerCase();
        String thuDucName = removeDiacritics("Thành phố Thủ Đức").toLowerCase();
        bool isHCM = countryCode == "vn" &&
            ((state != null &&
                    removeDiacritics(state).toLowerCase() == hcmName) ||
                (city != null &&
                    (removeDiacritics(city).toLowerCase() == hcmName ||
                        removeDiacritics(city).toLowerCase() == thuDucName)) ||
                (county != null &&
                    (removeDiacritics(county).toLowerCase() == hcmName ||
                        removeDiacritics(county).toLowerCase() == thuDucName)));
        if (!isHCM) {
          throw Exception(
              'Địa chỉ không thuộc TP.HCM (tỉnh/thành: ${state ?? city ?? county ?? "không xác định"}).');
        }

        // Xử lý địa chỉ chi tiết
        String? districtName = data["address"]["suburb"] ??
            data["address"]["city_district"] ??
            data["address"]["county"];
        if (city != null &&
            removeDiacritics(city).toLowerCase() == thuDucName) {
          districtName = city;
        }
        String? communeName =
            city != null && removeDiacritics(city).toLowerCase() == thuDucName
                ? (data["address"]["suburb"] ?? data["address"]["quarter"])
                : (data["address"]["quarter"] ?? data["address"]["suburb"]);
        String? subUnit = data["address"]["neighbourhood"] ??
            data["address"]["quarter"] ??
            data["address"]["hamlet"];
        String fullAddressString = data["display_name"] ?? "";

        List<String> addressParts = fullAddressString
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        Set<String> removeParts = {
          data["address"]["suburb"],
          data["address"]["city_district"],
          data["address"]["city"],
          data["address"]["state"],
          data["address"]["county"],
          data["address"]["postcode"],
          data["address"]["country"],
          data["address"]["quarter"],
        }.whereType<String>().map((e) => e.trim()).toSet();

        addressParts.removeWhere((part) => removeParts.contains(part));
        addressParts.removeWhere((part) => part == "Thành phố Hồ Chí Minh");

        if (subUnit != null &&
            subUnit.trim().isNotEmpty &&
            !addressParts.contains(subUnit.trim()) &&
            city != null &&
            removeDiacritics(city).toLowerCase() == thuDucName) {
          addressParts.add(subUnit.trim());
        }

        fullAddressString = addressParts.join(', ');

        if (districts.isEmpty) {
          await fetchDistricts('79');
        }

        // Map districtName to districtId
        String? districtId;
        if (districtName != null && districts.isNotEmpty) {
          String searchName = removeDiacritics(districtName).toLowerCase();
          districtId = districts.firstWhere(
            (district) {
              String fullName =
                  removeDiacritics(district.fullName).toLowerCase();
              String search = removeDiacritics(districtName!).toLowerCase();

              String normalize(String name) {
                return name
                    .replaceAll(
                        RegExp(r'(quan|huyen|thi xa|tp|thanh pho)',
                            caseSensitive: false),
                        '')
                    .replaceAll(RegExp(r'\s+'), '')
                    .trim();
              }

              return normalize(fullName) == normalize(search);
            },
            orElse: () => null,
          )?.id;
        }

        if (districtId != null) {
          await fetchCommunes(districtId);
          updateSelectedDistrictId(districtId);
        } else {
          Loaders.errorSnackBar(
              title: "Cảnh báo",
              message:
                  "Không thể xác định quận/huyện chính xác. Vui lòng chọn quận/huyện từ danh sách.");
        }

        String? communeId;
        if (communeName != null && districtId != null) {
          String adjustedCommuneName = communeName;
          if (adjustedCommuneName.toLowerCase().contains("khu pho")) {
            adjustedCommuneName = city != null &&
                    removeDiacritics(city).toLowerCase() == thuDucName
                ? (data["address"]["suburb"] ?? data["address"]["quarter"])
                : (data["address"]["quarter"] ?? data["address"]["suburb"]);
          }
          communeId = communes.isNotEmpty
              ? communes.firstWhere(
                  (commune) {
                    String communeFullName =
                        removeDiacritics(commune.fullName).toLowerCase();
                    String searchName =
                        removeDiacritics(adjustedCommuneName).toLowerCase();
                    String numberSearch =
                        searchName.replaceAll(RegExp(r'[^0-9]'), '');
                    String numberCommune =
                        communeFullName.replaceAll(RegExp(r'[^0-9]'), '');
                    numberSearch = numberSearch.replaceAll(RegExp(r'^0+'), '');
                    numberCommune =
                        numberCommune.replaceAll(RegExp(r'^0+'), '');
                    bool isNumberMatch = numberSearch.isNotEmpty &&
                        numberCommune.isNotEmpty &&
                        numberSearch == numberCommune;
                    bool isNameMatch = communeFullName.contains(searchName) ||
                        searchName.contains(communeFullName);
                    return isNumberMatch || isNameMatch;
                  },
                  orElse: () => null,
                )?.id
              : null;
        }
        if (communeId != null) {
          updateSelectedCommuneId(communeId);
        }

        detailAddressController.text = fullAddressString;
        districtController.text = districtName ?? "";
        communeController.text = communeName ?? "";
        lengthDetailAddress.value = fullAddressString.length;

        updateFullAddress();
      } else {
        throw Exception(
            'Không thể lấy địa chỉ. Mã trạng thái: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy địa chỉ: $e');
    }
  }

  Future<void> fetchCurrentLocation() async {
    isSelectAddress = false;
    try {
      var position = await LocationService.getLocation();
      if (position == null) {
        Loaders.errorSnackBar(
            title: "Lỗi",
            message:
                "Không thể lấy vị trí hiện tại. Vui lòng kiểm tra quyền truy cập vị trí.");
        return;
      }
      bool isHCM = await _isWithinHCM(position.latitude, position.longitude);
      if (!isHCM) {
        latitude.value = 0.0;
        longitude.value = 0.0;
        Loaders.errorSnackBar(
          title: "Lỗi",
          message:
              "Vị trí hiện tại không thuộc Thành phố Hồ Chí Minh. Vui lòng chọn vị trí trong TP.HCM.",
        );
        return;
      }
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      await updateLocation(position.latitude, position.longitude);
    } catch (e) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: "Không thể lấy vị trí hiện tại: $e",
      );
    }
  }

  Future<Position?> fetchCurrentLocationForMap() async {
    try {
      return await LocationService.getLocation();
    } catch (e) {
      return null;
    }
  }

  // Hàm hiển thị popup bản đồ
  void showMapPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Map",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // --- Header ---
              Container(
                color: MyColors.darkPrimaryColor, // Màu nền bạn muốn

                child: Padding(
                  padding: const EdgeInsets.only(
                    top: MySizes.xl,
                    bottom: MySizes.sm,
                    left: 16,
                    right: MySizes.xs,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Chọn vị trí trên bản đồ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: MyColors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: MyColors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: FutureBuilder<LatLng>(
                  future: getInitialPositionForMap(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final initialCenter =
                        snapshot.data ?? const LatLng(10.7769, 106.7009);
                    return Obx(
                      () => FlutterMap(
                        options: MapOptions(
                          initialCenter: initialCenter,
                          initialZoom: 15.0,
                          onTap: (tapPosition, point) {
                            // Cập nhật tọa độ và đóng popup
                            updateLocationFromMap(
                                point.latitude, point.longitude);
                            Navigator.pop(context);
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.example.food_delivery_h2d',
                          ),
                          MarkerLayer(
                            markers: [
                              if (latitude.value != 0.0 &&
                                  longitude.value != 0.0)
                                Marker(
                                  point:
                                      LatLng(latitude.value, longitude.value),
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
