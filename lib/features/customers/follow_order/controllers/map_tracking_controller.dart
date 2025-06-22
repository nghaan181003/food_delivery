import 'dart:async';
import 'package:food_delivery_h2d/data/map/map_repository.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class MapTrackingController extends GetxController {
  static MapTrackingController get instance => Get.find();

  final MapRepository _mapRepository = Get.put(MapRepository());
  final OrderSocketHandler _orderSocketHandler = OrderSocketHandler();

  var shipperLocation = const LatLng(10.7769, 106.7009).obs;
  var restaurantLocation = const LatLng(10.7955, 106.6841).obs;
  var customerLocation = const LatLng(10.8231, 106.6297).obs;
  var routePoints = <LatLng>[].obs;
  var lastFetchTime = DateTime.now().obs;
  Timer? _animationTimer;
  Timer? _fetchRouteTimer;

  void initializeWithOrder(Order order) {
    shipperLocation.value = LatLng(
      order.shipperLat ?? 10.7769,
      order.shipperLng ?? 106.7009,
    );
    restaurantLocation.value = LatLng(
      order.restLat ?? 10.7955,
      order.restLng ?? 106.6841,
    );
    customerLocation.value = LatLng(
      order.custLat ?? 10.8231,
      order.custLng ?? 10.6297,
    );
    _orderSocketHandler.joinRoom(order.id);

    _orderSocketHandler.listenForOrderUpdates((newOrder) {
      if (newOrder.shipperLat != null && newOrder.shipperLng != null) {
        final newLat = newOrder.shipperLat;
        final newLng = newOrder.shipperLng;
        updateRoutePoints(LatLng(newLat!, newLng!));
        shipperLocation.value = LatLng(newLat, newLng);
      }
    });

    fetchRoute();
    _fetchRouteTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchRoute();
    });
  }

  void updateRoutePoints(LatLng currentPosition) {
    if (routePoints.isEmpty) return;

    int closestIndex = 0;
    double minDistance = double.infinity;
    for (int i = 0; i < routePoints.length; i++) {
      final distance = math.sqrt(
        math.pow(currentPosition.latitude - routePoints[i].latitude, 2) +
            math.pow(currentPosition.longitude - routePoints[i].longitude, 2),
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    if (closestIndex >= 0 && closestIndex < routePoints.length) {
      routePoints.removeRange(0, closestIndex);
    }
  }

  void updateDriverLocation(double lat, double lng) {
    shipperLocation.value = LatLng(lat, lng);
  }

  Future<void> fetchRoute({int retryCount = 10, int delaySeconds = 1}) async {
    try {
      if (shipperLocation.value.latitude == 0.0 ||
          shipperLocation.value.longitude == 0.0 ||
          restaurantLocation.value.latitude == 0.0 ||
          restaurantLocation.value.longitude == 0.0 ||
          customerLocation.value.latitude == 0.0 ||
          customerLocation.value.longitude == 0.0) {
        routePoints.clear();
        return;
      }

      List<LatLng> points = await _mapRepository.fetchRoute(
        shipperLocation.value,
        restaurantLocation.value,
        customerLocation.value,
      );
      routePoints.assignAll(points);
      lastFetchTime.value = DateTime.now();
    } catch (e) {
      print('Error fetching route: $e');
      if (e.toString().contains('status code 503') && retryCount > 0) {
        print('Retrying fetchRoute... ($retryCount attempts left)');
        await Future.delayed(Duration(seconds: delaySeconds));
        await fetchRoute(
            retryCount: retryCount - 1, delaySeconds: delaySeconds);
      } else {
        print(" Failed to fetch route after retries: $e");
      }
    }
  }

  void animateToLocation(LatLng newLocation) {
    final oldLocation = shipperLocation.value;
    const steps = 10;
    const duration = Duration(milliseconds: 1000);
    int currentStep = 0;

    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(duration ~/ steps, (timer) {
      if (currentStep >= steps) {
        timer.cancel();
        shipperLocation.value = newLocation;
        return;
      }

      final t = currentStep / steps;
      final lat = oldLocation.latitude +
          (newLocation.latitude - oldLocation.latitude) * t;
      final lng = oldLocation.longitude +
          (newLocation.longitude - oldLocation.longitude) * t;
      shipperLocation.value = LatLng(lat, lng);
      currentStep++;
    });
  }

  Future<void> getCoordinatesFromAddress(String address, String type) async {
    try {
      LatLng? location =
          await _mapRepository.getCoordinatesFromAddress(address);
      if (location != null) {
        if (type == 'shipper') {
          shipperLocation.value = location;
        } else if (type == 'restaurant') {
          restaurantLocation.value = location;
        } else if (type == 'customer') {
          customerLocation.value = location;
        }
        fetchRoute();
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lấy tọa độ: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _orderSocketHandler.cleanUp();
    super.onClose();
  }
}
