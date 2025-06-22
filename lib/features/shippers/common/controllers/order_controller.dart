import 'package:flutter/foundation.dart';
import 'package:food_delivery_h2d/data/driver/driver_repository.dart';
import 'package:food_delivery_h2d/data/location/location_%20model.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/address_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/delivery_screen.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:latlong2/latlong.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  var newOrders = <Order>[].obs;
  var orders = <Order>[].obs;
  var filteredOrders = <Order>[].obs;

  var isLoading = true.obs;
  OrderRepository orderRepository = Get.put(OrderRepository());
  final addressController = Get.put(AddressController());
  final orderHandler = OrderSocketHandler();

  final _driverRepository = Get.put(DriverRepository());

  @override
  void onInit() {
    super.onInit();
    fetchNewOrders();
    fetchAllOrders();
  }

  final Distance distance = const Distance();

  Future<void> fetchNewOrders() async {
    try {
      isLoading(true);

      if (LoginController.instance.currentUser.workingStatus) {
        final fetchedOrders =
            await orderRepository.getOrdersByStatus(driverStatus: "waiting");
        List<Order> orders = fetchedOrders.where((order) {
          return ((order.paymentMethod == "VNPay" &&
                  order.paymentStatus == "paid") ||
              (order.paymentMethod == "Cash"));
        }).toList();
        orders.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
        newOrders.assignAll(orders);
      } else {
        newOrders.clear();
      }
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllOrders() async {
    try {
      isLoading(true);
      print(LoginController.instance.currentUser.driverId);
      final fetchedOrders = await orderRepository
          .getOrdersByDriverId(LoginController.instance.currentUser.driverId);

      // List<Order> ordersWithFullAddress = await Future.wait(
      //   fetchedOrders.map((order) async {
      //     order.restAddress = await addressController.getFullAddress(
      //       order.restProvinceId,
      //       order.restDistrictId,
      //       order.restCommuneId,
      //       order.restDetailAddress,
      //     );
      //     return order;
      //   }),
      // );

      orders.assignAll(fetchedOrders);
      orders.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOrderDriverByStatuses(List<String> driverStatus) async {
    try {
      isLoading(true);
      final fetchedOrders = await orderRepository.getOrdersByDriverId(
          LoginController.instance.currentUser.driverId,
          driverStatus: driverStatus);

      // List<Order> ordersWithFullAddress = await Future.wait(
      //   fetchedOrders.map((order) async {
      //     order.restAddress = await addressController.getFullAddress(
      //       order.restProvinceId,
      //       order.restDistrictId,
      //       order.restCommuneId,
      //       order.restDetailAddress,
      //     );
      //     return order;
      //   }),
      // );

      orders.assignAll(fetchedOrders);
      orders.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateOrderStatus(
    String? driverId, {
    required String orderId,
    required Map<String, dynamic> newStatus,
  }) async {
    try {
      final currentLocation = LoginController.instance.currentLocation;
      LatLng? driverLocation;
      if (currentLocation != null) {
        driverLocation = LatLng(
          currentLocation['latitude'],
          currentLocation['longitude'],
        );
      } else {
        Loaders.errorSnackBar(
          title: "Không tìm thấy vị trí",
          message:
              "Vui lòng cập nhật vị trí hiện tại của bạn trước khi nhận đơn.",
        );
        return;
      }

      final response =
          await orderRepository.updateOrderStatusWithDriverLocation(
        orderId,
        LoginController.instance.currentUser.driverId,
        newStatus,
        driverLocation != null
            ? {
                'latitude': driverLocation.latitude,
                'longitude': driverLocation.longitude
              }
            : null,
      );

      if (response.status == Status.ERROR) {
        return;
      }
      // await orderRepository.updateOrderStatus(
      //     orderId, driverId, newStatus, null);

      final orderIndex = orders.indexWhere((o) => o.id == orderId);
      if (orderIndex != -1) {
        orders[orderIndex].custStatus = newStatus['custStatus'];
        orders[orderIndex].driverStatus = newStatus['driverStatus'];
        orders[orderIndex].restStatus = newStatus['restStatus'];
        orders[orderIndex].assignedShipperId = driverId;
        orders.refresh();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDriverLocation(String orderId,
      {double? lat, double? lng}) async {
    try {
      LatLng? driverLocation;

      if (lat != null && lng != null) {
        driverLocation = LatLng(lat, lng);
      } else {
        final currentLocation = LoginController.instance.currentLocation;
        if (currentLocation != null) {
          driverLocation = LatLng(
            currentLocation['latitude'],
            currentLocation['longitude'],
          );
        } else {
          Loaders.errorSnackBar(
            title: "Không tìm thấy vị trí",
            message: "Vui lòng bật vị trí để cập nhật vị trí tài xế.",
          );
          return;
        }
      }

      final response = await orderRepository.updateDriverLocation(
        orderId,
        driverLocation.latitude,
        driverLocation.longitude,
        DateTime.now().toIso8601String(),
      );

      final updatedOrder = response.data;
      if (updatedOrder != null) {
        final orderIndex = orders.indexWhere((o) => o.id == orderId);
        if (orderIndex != -1) {
          orders[orderIndex].shipperLat = updatedOrder.shipperLat;
          orders[orderIndex].shipperLng = updatedOrder.shipperLng;
          orders.refresh();
        }
      }

      final driverId = LoginController.instance.currentUser.driverId;

      // Update current loacation of driver
      await _driverRepository.updateCurrentPosition(driverId,
          LocationModel(driverLocation.latitude, driverLocation.longitude, 15));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptOrder(Order order) async {
    final invalidOrders = orders.where((order) =>
        order.assignedShipperId ==
            LoginController.instance.currentUser.driverId &&
        order.driverStatus != 'delivered' &&
        order.driverStatus != 'cancelled' &&
        order.driverStatus != 'failed' &&
        order.driverStatus != 'reported' &&
        order.driverStatus != 'approved' &&
        order.driverStatus != 'rejected');

    if (invalidOrders.isNotEmpty) {
      Loaders.errorSnackBar(
        title: "Nhận đơn thất bại",
        message: "Bạn không thể nhận đơn vì có đơn hàng chưa hoàn thành.",
      );
      return;
    }
    try {
      ApiResponse<Order> orderResponse =
          await OrderRepository.instance.getOrderById(order.id);
      Order? newOrder = orderResponse.data!;
      if (newOrder.assignedShipperId == null ||
          newOrder.driverStatus != 'cancelled') {
        final currentLocation = LoginController.instance.currentLocation;
        Map<String, dynamic> newStatus = {
          "custStatus": "heading_to_rest",
          "driverStatus": "heading_to_rest",
          "restStatus": "new",
          "shipperLatitude": currentLocation['latitude'],
          "shipperLongitude": currentLocation['longitude'],
        };

        LatLng? driverLocation;
        if (currentLocation != null) {
          driverLocation = LatLng(
            currentLocation['latitude'],
            currentLocation['longitude'],
          );
        } else {
          Loaders.errorSnackBar(
            title: "Không tìm thấy vị trí",
            message:
                "Vui lòng cập nhật vị trí hiện tại của bạn trước khi nhận đơn.",
          );
          return;
        }

        final response =
            await orderRepository.updateOrderStatusWithDriverLocation(
          order.id,
          LoginController.instance.currentUser.driverId,
          newStatus,
          driverLocation != null
              ? {
                  'latitude': driverLocation.latitude,
                  'longitude': driverLocation.longitude
                }
              : null,
        );

        if (response.status == Status.ERROR) {
          Loaders.errorSnackBar(
            title: "Thất bại!",
            message: response.message,
          );
          return;
        }

        // await updateOrderStatus(
        //   LoginController.instance.currentUser.driverId,
        //   orderId: order.id,
        //   newStatus: newStatus,
        // );

        orderHandler.updateStatusOrder(order.id, newStatus);
        orderHandler.updateDriverLocation(
            order.id, order.shipperLat ?? 0.0, order.shipperLng ?? 0.0);

        newOrders.removeWhere((o) => o.id == order.id);
        // Get.to(() => DeliveryScreen(order: order));
        Get.to(() => DeliveryScreen(order: order))?.then((_) {
          if (Get.isRegistered<OrderSocketHandler>()) {
            final OrderSocketHandler socketHandler =
                Get.find<OrderSocketHandler>();
            socketHandler
                .joinRoom(LoginController.instance.currentUser.driverId!);
          }
        });
      } else {
        Loaders.errorSnackBar(
          title: "Nhận đơn thất bại",
          message: "Đã có tài xế nhận đơn này. Vui lòng nhận đơn khác.",
        );
        return;
      }
    } catch (e) {
      debugPrint("Lỗi khi nhận đơn hàng: $e");
    }
  }
}
