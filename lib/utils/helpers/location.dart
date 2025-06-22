import 'dart:convert';
import 'dart:developer';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static const String locationIqApiKey = "pk.830e389b41abcec44116a981f89c54d4";
  static const String baseUrl = "https://us1.locationiq.com/v1";

  static Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final url = Uri.parse(
        "$baseUrl/reverse.php?key=$locationIqApiKey&lat=$latitude&lon=$longitude&format=json&accept-language=vi");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // log("📍 Dữ liệu từ LocationIQ: ${jsonEncode(data)}");

        // String? provinceName = data["address"]["state"];
        // if (provinceName == null ||
        //     HelperFunctions.removeDiacritics(provinceName.toLowerCase()) !=
        //         HelperFunctions.removeDiacritics(
        //             "Thành phố Hồ Chí Minh".toLowerCase())) {
        //   Loaders.errorSnackBar(
        //     title: "Cảnh báo",
        //     message: "Vị trí hiện tại không thuộc TP Hồ Chí Minh.",
        //   );
        //   return null;
        // }

        String fullAddress = data["display_name"] ?? "";

        String? postcode = data["address"]["postcode"];
        String? country = data["address"]["country"];

        List<String> removeParts = [];
        if (postcode != null) removeParts.add(postcode);
        if (country != null) removeParts.add(country);

        String removeString =
            removeParts.isNotEmpty ? ", ${removeParts.join(', ')}" : "";

        // Loại bỏ chuỗi postcode và country khỏi fullAddress
        if (removeString.isNotEmpty) {
          fullAddress = fullAddress.replaceAll(removeString, "").trim();
        }

        fullAddress = fullAddress.replaceAll(RegExp(r",\s*$"), "");

        if (fullAddress.isEmpty) {
          Get.snackbar("Lỗi", "Không thể lấy địa chỉ hợp lệ.");
          return null;
        }

        // print("🟢 Địa chỉ đầy đủ: $fullAddress");
        return fullAddress;
      } else {
        Get.snackbar("Lỗi", "Không thể lấy địa chỉ. Vui lòng thử lại.");
        return null;
      }
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: "Lỗi khi lấy địa chỉ: $e");
      return null;
    }
  }

  static Future<Map<String, double>?> getCoordinatesFromAddress(
      String address) async {
    final url = Uri.parse(
        "$baseUrl/search.php?key=$locationIqApiKey&q=${Uri.encodeComponent(address)}&format=json&accept-language=vi");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final result = data[0];
          String? provinceName = result["address"]?["state"];
          // if (provinceName == null ||
          //     HelperFunctions.removeDiacritics(provinceName.toLowerCase()) !=
          //         HelperFunctions.removeDiacritics(
          //             "Thành phố Hồ Chí Minh".toLowerCase())) {
          //   Get.snackbar(
          //     "Cảnh báo",
          //     "Địa chỉ không thuộc TP Hồ Chí Minh.",
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white,
          //   );
          //   return null;
          // }

          return {
            "latitude": double.parse(result["lat"]),
            "longitude": double.parse(result["lon"]),
          };
        }
      }

      return null;
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: "Lỗi khi tìm tọa độ: $e");
      return null;
    }
  }
}
