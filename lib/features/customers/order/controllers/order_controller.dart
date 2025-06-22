import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/payment/payment_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/address_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/services/zalopay_service.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CustomerOrderController extends GetxController {
  static CustomerOrderController get instance => Get.find();
  var isLoading = true.obs;
  var orders = <Order>[].obs;
  final orderRepository = Get.put(OrderRepository());
  final addressController = Get.put(AddressController());
  final zaloPayService = Get.put(ZalopayService());

  @override
  void onInit() {
    super.onInit();
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    try {
      isLoading(true);

      final fetchedOrders = await orderRepository
          .getOrdersByCustomerID(LoginController.instance.currentUser.userId);
      print(LoginController.instance.currentUser.userId);
      List<Order> ordersWithFullAddress = await Future.wait(
        fetchedOrders.map((order) async {
          order.restAddress = await addressController.getFullAddress(
            order.restProvinceId,
            order.restDistrictId,
            order.restCommuneId,
            order.restDetailAddress,
          );
          return order;
        }),
      );

      orders.assignAll(ordersWithFullAddress);
      orders.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOrderByStatuses(List<String> custStatuses) async {
    try {
      isLoading(true);

      final fetchedOrders = await orderRepository.getOrdersByCustomerID(
        LoginController.instance.currentUser.userId,
        custStatus: custStatuses,
      );

      List<Order> ordersWithFullAddress = await Future.wait(
        fetchedOrders.map((order) async {
          order.restAddress = await addressController.getFullAddress(
            order.restProvinceId,
            order.restDistrictId,
            order.restCommuneId,
            order.restDetailAddress,
          );
          return order;
        }),
      );

      orders.assignAll(ordersWithFullAddress);
      orders.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
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

  Future<void> processPayment(int totalPrice, String orderId) async {
    try {
      isLoading(true);
      final orderInfo = 'Thanh toán đơn hàng #$orderId';

      final result = await zaloPayService.payWithZaloPay(
        orderInfo: orderInfo,
        amount: totalPrice,
        orderId: orderId,
      );

      if (result == null) {
        throw Exception('Payment initiation failed');
      }

      if (result['return_code'] == 1) {
        Loaders.successSnackBar(
          title: 'Thành công',
          message: 'Thanh toán đơn hàng thành công!',
        );
        fetchAllOrders();
      } else {
        Loaders.errorSnackBar(
          title: 'Lỗi Thanh Toán',
          message: result['return_message'] ?? 'Thanh toán thất bại',
        );
      }
    } catch (e) {
      Loaders.errorSnackBar(
        title: 'Lỗi Thanh Toán',
        message: e.toString(),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> processPaymentByVNPay(int totalPrice, String orderId) async {
    try {
      isLoading(true);
      final orderInfo = 'Thanh toán đơn hàng #$orderId';

      final result = await zaloPayService.payWithZaloPay(
        orderInfo: orderInfo,
        amount: totalPrice,
        orderId: orderId,
      );

      if (result == null) {
        throw Exception('Payment initiation failed');
      }

      if (result['return_code'] == 1) {
        Loaders.successSnackBar(
          title: 'Thành công',
          message: 'Thanh toán đơn hàng thành công!',
        );
        fetchAllOrders();
      } else {
        Loaders.errorSnackBar(
          title: 'Lỗi Thanh Toán',
          message: result['return_message'] ?? 'Thanh toán thất bại',
        );
      }
    } catch (e) {
      Loaders.errorSnackBar(
        title: 'Lỗi Thanh Toán',
        message: e.toString(),
      );
    } finally {
      isLoading(false);
    }
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
      fetchAllOrders();

      // final orderIndex = orders.indexWhere((o) => o.id == orderId);
      // orders[orderIndex].restStatus = "cancelled";

      Loaders.successSnackBar(
        title: "Thành công!",
        message: "Đơn hàng đã được hủy thành công.",
      );
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }
}
