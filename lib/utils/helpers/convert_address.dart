import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class ConvertAddress {
  static const String apiKey =
      "5b3ce3597851110001cf6248624e1bd0362941f69f8006f0e3fec245"; // Thay bằng API Key của bạn

  static Future<LatLng?> getCoordinatesFromAddress(String? address) async {
    final encodedAddress = Uri.encodeComponent(address!);
    final url =
        "https://api.openrouteservice.org/geocode/search?api_key=$apiKey&text=$encodedAddress";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["features"].isNotEmpty) {
          double lon = data["features"][0]["geometry"]["coordinates"][0];
          double lat = data["features"][0]["geometry"]["coordinates"][1];
          return LatLng(lat, lon);
        } else {
          print("⚠️ Không tìm thấy tọa độ cho địa chỉ: $address");
        }
      } else {
        print("⚠️ Lỗi API OpenRouteService: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi OpenRouteService API: $e");
    }
    return null;
  }
}
