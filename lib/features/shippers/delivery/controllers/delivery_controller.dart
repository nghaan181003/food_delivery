import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/map/map_repository.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryController extends GetxController {
  static DeliveryController get instance => Get.find();
  final MapRepository _mapRepository = Get.put(MapRepository());
  final OrderRepository _orderRepository = Get.put(OrderRepository());

  final OrderController orderController = Get.find();
  final OrderSocketHandler orderSocketHandler = Get.put(OrderSocketHandler());
  final _orderSocketHandler = OrderSocketHandler();

  Stream<Position>? _locationStream;
  StreamSubscription<Position>? _locationSubscription;
  Timer? _mockLocationTimer;
  int _currentMockStep = 0;
  List<LatLng> _mockRoute = [];

  DateTime? _lastUpdate;

  var shipperLocation = const LatLng(10.7769, 106.7009).obs;
  var restaurantLocation = const LatLng(10.7955, 106.6841).obs;
  var customerLocation = const LatLng(10.8231, 106.6297).obs;

  @override
  void onClose() {
    stopLocationTracking();
    super.onClose();
  }

  Future<void> startMockLocationTracking(String orderId) async {
    final orderResponse = await _orderRepository.getOrderById(orderId);
    if (orderResponse.status == Status.ERROR) {
      Loaders.errorSnackBar(title: 'Lỗi', message: orderResponse.message);
      return;
    }
    final order = orderResponse.data as Order;
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
      order.custLng ?? 106.6297,
    );

    try {
      _mockRoute = await _mapRepository.fetchRoute(shipperLocation.value,
          restaurantLocation.value, customerLocation.value);
    } catch (e) {
      return;
    }

    _currentMockStep = 0;

    _mockLocationTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_currentMockStep < _mockRoute.length) {
        final mockPosition = _mockRoute[_currentMockStep];
        final driverLat = mockPosition.latitude;
        final driverLng = mockPosition.longitude;

        shipperLocation.value = LatLng(driverLat, driverLng);

        final now = DateTime.now();
        if (_lastUpdate == null ||
            now.difference(_lastUpdate!).inSeconds >= 3) {
          await orderController.updateDriverLocation(
            orderId,
            lat: driverLat,
            lng: driverLng,
          );
          orderSocketHandler.updateDriverLocation(
            orderId,
            driverLat,
            driverLng,
          );
          orderSocketHandler.updateStatusOrder(orderId, {});
          _lastUpdate = now;
        }

        _currentMockStep++;
      } else {
        _mockLocationTimer?.cancel();
        Loaders.successSnackBar(
          title: 'Hoàn thành',
          message: 'Tài xế đã đến điểm đích.',
        );
      }
    });
  }

  void stopMockLocationTracking() {
    _mockLocationTimer?.cancel();
    _mockLocationTimer = null;
    _currentMockStep = 0;
    _mockRoute = [];
    _lastUpdate = null;
  }

  void stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _locationStream = null;
    stopMockLocationTracking();
  }

  Future<void> startLocationTracking(String orderId,
      {bool isMock = false}) async {
    if (isMock) {
      await startMockLocationTracking(orderId);
    } else {
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
                title: 'Lỗi', message: 'Quyền truy cập vị trí bị từ chối');
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          Loaders.errorSnackBar(
              title: 'Lỗi',
              message:
                  'Quyền truy cập vị trí bị từ chối vĩnh viễn. Vui lòng cấp quyền trong cài đặt.');
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
            final driverLat = position.latitude;
            final driverLng = position.longitude;
            if (driverLat != 0.0 && driverLng != 0.0) {
              shipperLocation.value = LatLng(driverLat, driverLng);
              final now = DateTime.now();
              if (_lastUpdate == null ||
                  now.difference(_lastUpdate!).inSeconds >= 3) {
                await orderController.updateDriverLocation(
                  orderId,
                  lat: driverLat,
                  lng: driverLng,
                );
                orderSocketHandler.updateStatusOrder(orderId, {});

                orderSocketHandler.updateDriverLocation(
                  orderId,
                  driverLat,
                  driverLng,
                );
                _lastUpdate = now;
              }
            }
          },
          onError: (e) async {
            final lastLocation = await Geolocator.getLastKnownPosition();
            if (lastLocation != null) {
              shipperLocation.value =
                  LatLng(lastLocation.latitude, lastLocation.longitude);
              final now = DateTime.now();
              if (_lastUpdate == null ||
                  now.difference(_lastUpdate!).inSeconds >= 3) {
                await orderController.updateDriverLocation(
                  orderId,
                  lat: lastLocation.latitude,
                  lng: lastLocation.longitude,
                );

                orderSocketHandler.updateDriverLocation(
                  orderId,
                  lastLocation.latitude,
                  lastLocation.longitude,
                );
                _lastUpdate = now;
              }
            }
          },
        );
      } catch (e) {
        print('Error starting location tracking: $e');
      }
    }
  }

  // Mở Google Maps với lộ trình: tài xế -> quán ăn -> khách hàng
  Future<void> openGoogleMapsForOrder(Order order) async {
    final restaurantLat = order.restLat ?? 0.0;
    final restaurantLng = order.restLng ?? 0.0;
    final customerLat = order.custLat ?? 0.0;
    final customerLng = order.custLng ?? 0.0;

    final driverStatus = order.driverStatus;
    bool headingToRestaurant = driverStatus == 'heading_to_rest';

    if ((headingToRestaurant &&
            (restaurantLat == 0.0 || restaurantLng == 0.0)) ||
        (!headingToRestaurant && (customerLat == 0.0 || customerLng == 0.0))) {
      Loaders.errorSnackBar(title: 'Lỗi', message: 'Tọa độ không hợp lệ');
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()));
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Get.back();
      final driverLat = position.latitude;
      final driverLng = position.longitude;

      if (driverLat == 0.0 || driverLng == 0.0) {
        Loaders.errorSnackBar(
            title: 'Lỗi', message: 'Không thể lấy vị trí tài xế');
        return;
      }

      final googleMapsUrl = headingToRestaurant
          ? Uri.parse('https://www.google.com/maps/dir/?api=1'
              '&origin=${Uri.encodeComponent('$driverLat,$driverLng')}'
              '&destination=${Uri.encodeComponent('$restaurantLat,$restaurantLng')}'
              '&travelmode=driving')
          : Uri.parse('https://www.google.com/maps/dir/?api=1'
              '&origin=${Uri.encodeComponent('$driverLat,$driverLng')}'
              '&destination=${Uri.encodeComponent('$customerLat,$customerLng')}'
              '&waypoints=${Uri.encodeComponent('$restaurantLat,$restaurantLng')}'
              '&travelmode=driving');

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      Get.back();
      Loaders.errorSnackBar(
          title: 'Lỗi', message: 'Không thể mở Google Maps: $e');
    }
  }

  Future<void> showCancelDialog(BuildContext context, String orderId) async {
    TextEditingController reasonController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hủy đơn hàng'),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: 'Lý do hủy đơn',
              hintText: 'Nhập lý do...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  cancelOrder(orderId, reason);
                  Navigator.of(context).pop();
                } else {
                  Loaders.errorSnackBar(
                    title: "Lỗi",
                    message: "Lý do không được để trống!",
                  );
                }
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showReportDialog(BuildContext context, String orderId) async {
    TextEditingController contentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Báo cáo đơn hàng'),
          content: TextField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'Nội dung báo cáo',
              hintText: 'Nhập nội dung...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final content = contentController.text.trim();
                if (content.isNotEmpty) {
                  reportOrder(orderId, content);
                  Navigator.of(context).pop();
                } else {
                  Loaders.errorSnackBar(
                    title: "Lỗi",
                    message: "Nội dung không được để trống!",
                  );
                }
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  void cancelOrder(String orderId, String reason) async {
    try {
      Map<String, dynamic> newStatus = {
        "custStatus": "cancelled",
        "driverStatus": "cancelled",
        "restStatus": "cancelled",
      };

      final res = await OrderRepository.instance
          .updateOrderStatus(orderId, null, newStatus, reason);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }
      Get.back();

      _orderSocketHandler.updateStatusOrder(orderId, newStatus);

      OrderController.instance.fetchAllOrders();
      OrderController.instance.fetchNewOrders();

      Loaders.successSnackBar(
        title: "Thành công!",
        message: "Đơn hàng đã được hủy thành công.",
      );
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }

  void reportOrder(String orderId, String reason) async {
    try {
      Map<String, dynamic> newStatus = {
        "custStatus": "cancelled",
        "driverStatus": "reported",
        "restStatus": "cancelled",
      };

      final res = await OrderRepository.instance
          .updateOrderStatus(orderId, null, newStatus, reason);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }
      Get.back();

      _orderSocketHandler.updateStatusOrder(orderId, newStatus);

      OrderController.instance.fetchAllOrders();
      OrderController.instance.fetchNewOrders();

      Loaders.successSnackBar(
        title: "Thành công!",
        message: "Báo cáo đơn hàng thành công. Hệ thống sẽ xem xét và xử lý.",
      );
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }
}
