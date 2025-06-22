import 'package:food_delivery_h2d/features/restaurants/order_management/models/order_item_model.dart';

class OrderModel {
  int orderId;
  int customerId;
  int restaurantId;
  int assignedShipperId;
  double custShipperRating;
  String deliveryFeedback;
  DateTime orderDateTime;
  String note;
  List<OrderItem> orderItems; // Thêm danh sách OrderItem

  OrderModel({
    this.orderId = 0,
    this.customerId = 0,
    this.restaurantId = 0,
    this.assignedShipperId = 0,
    this.custShipperRating = 0,
    this.deliveryFeedback = "",
    DateTime? orderDateTime,
    this.note = '',
    this.orderItems = const [], // Khởi tạo mặc định là danh sách rỗng
  }) : orderDateTime = orderDateTime ?? DateTime.now();

  int get totalQuantity {
    return orderItems.fold(0, (sum, item) => sum + item.quantity);
  }
}