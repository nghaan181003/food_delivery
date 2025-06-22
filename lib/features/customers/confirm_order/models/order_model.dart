import 'package:food_delivery_h2d/features/customers/confirm_order/models/order_item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';

class OrderModel {
  String id;
  String customerId;
  String restaurantId;
  String custAddress;
  double? custLatitude;
  double? custLongitude;
  double? shipperLatitude;
  double? shipperLongitude;
  double? restLatitude;
  double? restLongitude;
  double deliveryFee;
  DateTime orderDatetime;
  String note;
  List<OrderItem> orderItems;
  int totalPrice;
  String paymentMethod;
  String paymentStatus;

  OrderModel({
    this.id = '',
    this.customerId = '',
    this.restaurantId = '',
    this.custAddress = '',
    this.custLatitude = 0,
    this.custLongitude = 0,
    this.shipperLatitude = 0,
    this.shipperLongitude = 0,
    this.restLatitude = 0,
    this.restLongitude = 0,
    this.deliveryFee = 0,
    DateTime? orderDatetime,
    this.note = '',
    required this.orderItems,
    this.totalPrice = 0,
    this.paymentMethod = 'Cash',
    this.paymentStatus = 'pending',
  }) : orderDatetime = orderDatetime ?? DateTime.now();

  // Convert an Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      'custAddress': custAddress,
      'custLatitude': custLatitude,
      'custLongitude': custLongitude,
      'shipperLatitude': shipperLatitude,
      'shipperLongitude': shipperLongitude,
      'restLatitude': restLatitude,
      'restLongitude': restLongitude,
      'deliveryFee': deliveryFee,
      'orderDatetime': orderDatetime.toUtcIsoString,
      'note': note,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }

  // Factory constructor to create an Order object from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customerId'],
      restaurantId: json['restaurantId'],
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      orderDatetime: DateTime.parse(json['orderDatetime']),
      note: json['note'] ?? '',
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      custAddress: '',
      custLatitude: (json['custLatitude'] as num).toDouble(),
      custLongitude: (json['custLongitude'] as num).toDouble(),
      shipperLatitude: (json['shipperLatitude'] as num).toDouble(),
      shipperLongitude: (json['shipperLongitude'] as num).toDouble(),
      restLatitude: (json['restLatitude'] as num).toDouble(),
      totalPrice: json['totalPrice'],
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      paymentStatus: json['paymentStatus'] ?? 'pending',
    );
  }

  @override
  String toString() {
    return 'Order('
        'id: $id, '
        'customerId: $customerId, '
        'restaurantId: $restaurantId, '
        'deliveryFee: $deliveryFee, '
        'orderDatetime: $orderDatetime, '
        'note: $note, '
        'orderItems: $orderItems'
        'totalPrice: $totalPrice'
        ', paymentMethod: $paymentMethod, '
        'paymentStatus: $paymentStatus'
        ')';
  }
}
