import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/config/config_repository.dart';
import 'package:food_delivery_h2d/data/distance/distance_repository.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/data/voucher/voucher_repository.dart';
import 'package:food_delivery_h2d/features/admin/config/models/fee_config_model.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/address_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/distance_model.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/order_item_model.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/order_model.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/follow_order_screen.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/detail_partner_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/request/get_voucher_order_request.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final TextEditingController noteController = TextEditingController();
  final orderRepository = Get.put(OrderRepository());
  final voucherRepository = Get.put(VoucherRepository());
  final configRepository = Get.put(ConfigRepository());
  final distanceRepository = Get.put(DistanceRepository());
  final CartController cartController = Get.find();
  final AddressController addressController = Get.put(AddressController());
  final addressSelectionController = Get.put(AddressSelectionController());
  late final OrderModel order = OrderModel(orderItems: []);
  var deliveryFee = 0.0.obs;
  var distance = 0.0.obs;
  var baseDistance = 1.0;
  var isCalculatingFee = false.obs;
  // double get totalAmount => order.totalPrice + order.deliveryFee;
  var totalAmount = 0.0.obs;
  var voucherDiscount = 0.obs;

  var paymentMethod = 'Cash'.obs;
  var distanceData = Rxn<Distance>();
  var deliveryConfig = Rxn<Config>();
  var restaurantDetail = Rxn<DetailPartnerModel>();

  final _orderSocketHandler = Get.put(OrderSocketHandler());

  final List<VoucherModel> vouchers = <VoucherModel>[];
  var isGetVouchersLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    RestaurantController.instance
        .fetchDetailPartner(RestaurantController.instance.userId);
    restaurantDetail.value = RestaurantController.instance.detailPartner.value;
    fetchDeliveryFeeConfig();
    convertCartItemToOrderItem();

    // Debounce thay đổi tọa độ
    debounce(addressSelectionController.latitude, (_) => onLocationChanged(),
        time: const Duration(milliseconds: 500));
    debounce(addressSelectionController.longitude, (_) => onLocationChanged(),
        time: const Duration(milliseconds: 500));

    totalAmount.value = order.totalPrice.toDouble();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void onLocationChanged() {
    order.custLatitude = addressSelectionController.latitude.value;
    order.custLongitude = addressSelectionController.longitude.value;
    calculateDeliveryFee();
  }

  Future<void> fetchDeliveryFeeConfig() async {
    try {
      final response = await configRepository.getDeliveryFeeConfig();
      if (response.status == Status.OK && response.data != null) {
        deliveryConfig.value = response.data;
        calculateDeliveryFee();
      } else {
        throw Exception('Lỗi API: ${response.message}');
      }
    } catch (e) {
      deliveryConfig.value = null;
      deliveryFee.value = 0.0;
    }
  }

  Future<double?> getDistanceFromBackend() async {
    await RestaurantController.instance
        .fetchDetailPartner(RestaurantController.instance.userId);
    var restaurantDetail = RestaurantController.instance.detailPartner.value;
    if (addressSelectionController.latitude.value == 0.0 ||
        addressSelectionController.longitude.value == 0.0 ||
        restaurantDetail?.latitude == 0.0 ||
        restaurantDetail?.longitude == 0.0) {
      return null;
    }

    final point1 = {
      'lat': addressSelectionController.latitude.value,
      'lng': addressSelectionController.longitude.value
    };
    final point2 = {
      'lat': restaurantDetail?.latitude,
      'lng': restaurantDetail?.longitude,
    };

    try {
      final response = await distanceRepository.getDistance(point1, point2);
      if (response.status == Status.OK && response.data != null) {
        distanceData.value = response.data;
        distance.value = distanceData.value!.distance!;
        return distance.value;
      } else {
        throw Exception('Lỗi API: ${response.message}');
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> calculateDeliveryFee() async {
    isCalculatingFee.value = true;
    try {
      final responseData = await orderRepository.calcDeliveryFee(
          customerLat: order.custLatitude ?? 0,
          customerLng: order.custLongitude ?? 0,
          restaurantId: RestaurantController.instance.userId);
      deliveryFee.value = responseData.data?["deliveryFee"];

      final distance = responseData.data?["distance"];
      if (distance == null) {
        deliveryFee.value = 0.0;
        order.deliveryFee = deliveryFee.value;
        totalAmount.value = order.totalPrice as double;
        return;
      }

      order.deliveryFee = deliveryFee.value;
      totalAmount.value = order.totalPrice + order.deliveryFee;
    } finally {
      isCalculatingFee.value = false;
    }
  }

  void convertCartItemToOrderItem() {
    // order.orderItems.clear();
    if (order.orderItems.isEmpty) {
      for (var cartItem in cartController.cartItems) {
        order.orderItems.add(OrderItem(
          toppings: cartItem.selectedToppings,
          itemName: cartItem.itemName,
          price: cartItem.price,
          quantity: cartController.itemQuantities[cartItem.uniqueKey] ?? 0,
          totalPrice: cartItem.totalItemPrice.toInt() *
              cartController.itemQuantities[cartItem.uniqueKey]!,
          itemId: cartItem.itemId,
        ));
      }
      order.totalPrice =
          order.orderItems.fold(0, (sum, item) => sum + item.totalPrice);
      order.deliveryFee = deliveryFee.value;
    }
  }

  Future<void> placeOrder() async {
    convertCartItemToOrderItem();
    OrderModel newOrder = OrderModel(
      custAddress: order.custAddress,
      custLatitude: order.custLatitude,
      custLongitude: order.custLongitude,
      customerId: LoginController.instance.currentUser.userId,
      restaurantId: RestaurantController.instance.userId,
      restLatitude: order.restLatitude,
      restLongitude: order.restLongitude,
      deliveryFee: deliveryFee.value,
      orderItems: order.orderItems,
      totalPrice: order.totalPrice,
      note: noteController.text,
      paymentMethod: paymentMethod.value,
      paymentStatus: 'pending',
    );
    ApiResponse<Order> createdOrder =
        await orderRepository.placeOrder(newOrder);

    if (createdOrder.status == Status.OK) {
      var orderDetail = createdOrder.data!;
      cartController.removeAllItem();

      ApiResponse<Order> orderResponse =
          await orderRepository.getOrderById(orderDetail.id);
      Loaders.successSnackBar(
          title: "Thành công", message: "Đặt hàng thành công.");
      order.orderItems.clear();

      Order? responseOrder = orderResponse.data;
      responseOrder?.restAddress = await addressController.getFullAddress(
        responseOrder.restProvinceId,
        responseOrder.restDistrictId,
        responseOrder.restCommuneId,
        responseOrder.restDetailAddress,
      );
      Get.to(() => FollowOrderScreen(order: responseOrder!));
      _orderSocketHandler.createOrder(orderResponse.data!);
    } else {
      Loaders.errorSnackBar(
          title: "Lỗi", message: "Không thể đặt hàng. Vui lòng thử lại.");
    }
  }

  /*
      partnerId: partnerId,
        productIds: cartController.cartItems
            .map((item) => item.itemId)
            .toList(),
        totalOrderAmount: order.totalPrice,
        userId: LoginController.instance.currentUser.userId,
   */

  Future<void> getVouchersInOrder() async {
    try {
      isGetVouchersLoading.value = true;
      final shopId = RestaurantController.instance.userId;

      final response = await voucherRepository.getVoucherInOrder(
          GetVoucherOrderRequest(
              shopId: shopId,
              productIds: order.orderItems.map((e) => e.itemId).toList(),
              totalOrderAmount: order.totalPrice,
              userId: LoginController.instance.currentUser.userId));

      if (response.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: response.message);
        return;
      }

      vouchers.assignAll(response.data ?? []);
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
    } finally {
      isGetVouchersLoading.value = false;
    }
  }

  Future<void> getVoucherByCode(String code) async {
    try {
      isGetVouchersLoading.value = true;
      final shopId = RestaurantController.instance.userId;

      final response = await voucherRepository.getVoucherByCode(
          GetVoucherOrderRequest(
              shopId: shopId,
              productIds: order.orderItems.map((e) => e.itemId).toList(),
              totalOrderAmount: order.totalPrice,
              userId: LoginController.instance.currentUser.userId,
              code: code));

      if (response.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: response.message);
        return;
      }
      vouchers.assignAll(response.data ?? []);
    } catch (e) {
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
    } finally {
      isGetVouchersLoading.value = false;
    }
  }

  double get totalOrderAmount =>
      order.totalPrice + deliveryFee.value - voucherDiscount.value;
}
