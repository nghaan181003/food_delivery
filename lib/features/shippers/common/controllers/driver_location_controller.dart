import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/driver/driver_repository.dart';
import 'package:food_delivery_h2d/data/location/location_%20model.dart';
import 'package:food_delivery_h2d/data/map/map_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/authentication/models/User.dart';
import 'package:food_delivery_h2d/services/location_service.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';

class DriverLocationController extends GetxController {
  static DriverLocationController get instance => Get.find();

  final DriverRepository _driverRepository = Get.put(DriverRepository());
  final MapRepository _mapRepository = Get.put(MapRepository());
  final _localStorage = GetStorage();

  Stream<Position>? _locationStream;
  StreamSubscription<Position>? _locationSubscription;
  Timer? _mockLocationTimer;
  int _currentMockStep = 0;
  List<LatLng> _mockRoute = [];

  var driverLocation = const LatLng(10.7769, 106.7009).obs;
  var isTracking = false.obs;
  DateTime? _lastUpdate;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    stopLocationTracking();
    super.onClose();
  }

  void saveLocation(Position position) {
    final locationData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': position.timestamp.toIso8601String(),
    };
    _localStorage.write('currentLocation', locationData);
  }

  Future<void> startLocationTracking(String driverId,
      {bool isMock = false}) async {
    if (isTracking.value) {
      return;
    }

    if (isMock) {
      await startMockLocationTracking(driverId);
    } else {
      await startRealLocationTracking(driverId);
    }
  }

  Future<void> updateDriverLocation(String driverId, Position position) async {
    final currentUser = LoginController.instance.currentUser;
    if (currentUser == null || currentUser.userId != driverId) {
      stopLocationTracking();
      return;
    }

    try {
      final now = DateTime.now();
      if (_lastUpdate == null || now.difference(_lastUpdate!).inSeconds >= 5) {
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          saveLocation(position);
          Loaders.warningSnackBar(
            title: 'Không có kết nối',
            message: 'Vị trí sẽ được đồng bộ khi có mạng.',
          );
          return;
        }
        await _driverRepository.updateDriverLocation(driverId, position);
        _lastUpdate = now;
      }
      await _driverRepository.updateDriverLocation(driverId, position);

      await _driverRepository.updateCurrentPosition(
          LoginController.instance.currentUser.driverId,
          LocationModel(position.latitude, position.longitude, 15));
      driverLocation.value = LatLng(position.latitude, position.longitude);
      saveLocation(position);
    } catch (e) {
      print('Error updating driver location: $e');
    }
  }

  Future<void> startMockLocationTracking(String driverId) async {
    try {
      final currentLocationMap = LoginController.instance.currentLocation;

      Position initialPosition;
      if (currentLocationMap == null ||
          currentLocationMap['latitude'] == null ||
          currentLocationMap['longitude'] == null) {
        final newLocation = await LocationService.getLocation();
        if (newLocation == null) {
          return;
        }
        initialPosition = newLocation;
      } else {
        initialPosition = Position(
          latitude: currentLocationMap['latitude'] as double,
          longitude: currentLocationMap['longitude'] as double,
          timestamp: DateTime.parse(currentLocationMap['timestamp'] as String),
          accuracy: 10.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      }

      driverLocation.value =
          LatLng(initialPosition.latitude, initialPosition.longitude);
      saveLocation(initialPosition);

      final random = Random();
      const minRadiusKm = 5.0;
      const maxRadiusKm = 10.0;
      final radiusKm =
          minRadiusKm + random.nextDouble() * (maxRadiusKm - minRadiusKm);
      final angle = random.nextDouble() * 2 * pi;

      final radiusDeg = radiusKm * 0.009;
      final destinationA = LatLng(
        driverLocation.value.latitude + radiusDeg * cos(angle),
        driverLocation.value.longitude + radiusDeg * sin(angle),
      );

      final destinationB = LatLng(
        driverLocation.value.latitude - radiusDeg * cos(angle),
        driverLocation.value.longitude - radiusDeg * sin(angle),
      );

      _mockRoute = await _mapRepository.fetchRoute(
        driverLocation.value,
        destinationA,
        destinationB,
      );

      _currentMockStep = 0;
      isTracking.value = true;

      DateTime? lastBackendUpdate = DateTime.now();
      const backendUpdateInterval = Duration(seconds: 10);

      _mockLocationTimer =
          Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (_currentMockStep < _mockRoute.length) {
          final mockPosition = _mockRoute[_currentMockStep];
          final position = Position(
            latitude: mockPosition.latitude,
            longitude: mockPosition.longitude,
            timestamp: DateTime.now(),
            accuracy: 10.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );

          driverLocation.value = LatLng(position.latitude, position.longitude);
          saveLocation(position);

          final now = DateTime.now();
          if (now.difference(lastBackendUpdate!).inSeconds >=
              backendUpdateInterval.inSeconds) {
            await updateDriverLocation(driverId, position);
            lastBackendUpdate = now;
          }

          _currentMockStep++;
        } else {
          stopMockLocationTracking();
        }
      });
    } catch (e) {
      isTracking.value = false;
    }
  }

  void stopMockLocationTracking() {
    _mockLocationTimer?.cancel();
    _mockLocationTimer = null;
    _currentMockStep = 0;
    _mockRoute = [];
    isTracking.value = false;
  }

  Future<void> startRealLocationTracking(String driverId) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Loaders.errorSnackBar(
          title: 'Lỗi',
          message: 'Dịch vụ định vị không được bật. Vui lòng bật GPS.',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Loaders.errorSnackBar(
            title: 'Lỗi',
            message: 'Quyền truy cập vị trí bị từ chối.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Loaders.errorSnackBar(
          title: 'Lỗi',
          message:
              'Quyền truy cập vị trí bị từ chối vĩnh viễn. Vui lòng cấp quyền trong cài đặt.',
        );
        return;
      }

      _locationStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );

      _locationSubscription = _locationStream!.listen(
        (Position position) async {
          await updateDriverLocation(driverId, position);
        },
        onError: (e) async {
          final lastLocation = await Geolocator.getLastKnownPosition();
          if (lastLocation != null) {
            await updateDriverLocation(driverId, lastLocation);
          }
        },
      );

      isTracking.value = true;
    } catch (e, stackTrace) {
      print('Error starting location tracking: $e\n$stackTrace');
      isTracking.value = false;
    }
  }

  void stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _locationStream = null;
    stopMockLocationTracking();
    isTracking.value = false;
  }

  void initializeLocationTracking(UserModel user) {
    if (user.role == 'driver') {
      startLocationTracking(user.userId, isMock: false);
    } else {}
  }

  Future<void> updateLocationOnLogout(String driverId) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await updateDriverLocation(driverId, position);
    } catch (e) {
    } finally {
      stopLocationTracking();
    }
  }
}
