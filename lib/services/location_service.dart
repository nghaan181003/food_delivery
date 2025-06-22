import 'package:food_delivery_h2d/services/permission_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getLocation() async {
    final hasPermission = await PermissionService.handleLocationPermission();
    if (!hasPermission) return null;

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }
}
