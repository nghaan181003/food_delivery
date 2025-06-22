import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/driver_location_controller.dart';
import 'package:food_delivery_h2d/services/location_service.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapWidgetController extends GetxController {
  var currentPosition = const LatLng(10.8231, 106.6297).obs;
  final mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }

  void _initializeLocation() async {
    await getCurrentLocation();

    ever(DriverLocationController.instance.driverLocation,
        (LatLng newLocation) {
      currentPosition.value =
          LatLng(newLocation.latitude, newLocation.longitude);
      _moveMapToPosition(newLocation);
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = DriverLocationController.instance.driverLocation.value;
      currentPosition.value = LatLng(position.latitude, position.longitude);
      _moveMapToPosition(currentPosition.value);
    } catch (e) {
      try {
        final newPosition = await LocationService.getLocation();
        if (newPosition != null) {
          currentPosition.value =
              LatLng(newPosition.latitude, newPosition.longitude);
          _moveMapToPosition(currentPosition.value);
        }
      } catch (fallbackError) {}
    }
  }

  void _moveMapToPosition(LatLng position) {
    try {
      mapController.move(position, 13.0);
    } catch (e) {}
  }
}
