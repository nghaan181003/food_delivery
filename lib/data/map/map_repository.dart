import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapRepository extends GetxController {
  static MapRepository get instance => Get.find();

  static const String _mapApi = "map";

  Future<List<LatLng>> fetchRoute(
      LatLng shipper, LatLng restaurant, LatLng customer) async {
    const String url = "$_mapApi/route";
    final Map<String, dynamic> body = {
      "shipper": {"lat": shipper.latitude, "lng": shipper.longitude},
      "restaurant": {"lat": restaurant.latitude, "lng": restaurant.longitude},
      "customer": {"lat": customer.latitude, "lng": customer.longitude},
    };

    try {
      final response = await HttpHelper.post(url, body);

      if (response.containsKey("route") &&
          response["route"].containsKey("combinedRoute")) {
        final List<dynamic> routeData = response["route"]["combinedRoute"];
        return routeData
            .map((coord) =>
                LatLng(coord['lat'] as double, coord['lng'] as double))
            .toList();
      }

      throw Exception(
          "Invalid response format: Missing 'route.combinedRoute' key.");
    } catch (e) {
      debugPrint("Error fetching route: $e");
      rethrow;
    }
  }

  Future<double?> getDistanceBetweenAddresses(
      String address1, String address2) async {
    final String url =
        "$_mapApi/distance?address1=${Uri.encodeComponent(address1)}&address2=${Uri.encodeComponent(address2)}";

    try {
      final response = await HttpHelper.get(url);
      if (response.containsKey('distance')) {
        return double.tryParse(response['distance'].replaceAll(" km", ""));
      }
      throw Exception("Invalid response format or missing distance.");
    } catch (e) {
      debugPrint("Error fetching distance: $e");
      return null;
    }
  }

  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final String url =
        "$_mapApi/geocode?address=${Uri.encodeComponent(address)}";

    try {
      final response = await HttpHelper.get(url);
      if (response.containsKey('lat') && response.containsKey('lng')) {
        return LatLng(response['lat'] as double, response['lng'] as double);
      }
      throw Exception("Invalid response format or missing data.");
    } catch (e) {
      debugPrint("Error fetching coordinates: $e");
      return null;
    }
  }
}
