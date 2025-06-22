import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_item_model.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:latlong2/latlong.dart';

class Order {
  String id;
  String customerName;
  String restaurantName;
  String? restaurantId;
  String? restDetailAddress;
  String? assignedShipperId;
  double? custShipperRating;
  int? deliveryFee;
  DateTime orderDatetime;
  String note;
  double? custResRating;
  String reason;
  String custStatus;
  String? driverStatus;
  String? restStatus;
  List<OrderItem> orderItems;
  String? restAddress;
  double? restLat;
  double? restLng;
  String? custAddress;
  double? custLat;
  double? custLng;
  String custPhone;
  int? totalPrice;
  String? driverName;
  String? driverPhone;
  String? driverLicensePlate;
  String? driverProfileUrl;
  String? restProvinceId;
  String? restDistrictId;
  String? restCommuneId;
  String? custResRatingComment;
  String? custShipperRatingComment;
  String? paymentMethod;
  String? paymentStatus;
  String customerId;
  double? shipperLat;
  double? shipperLng;
  DateTime? createdAt;

  Order(
      {this.id = '',
      required this.customerName,
      required this.restaurantName,
      this.restaurantId,
      this.restDetailAddress,
      required this.custPhone,
      this.assignedShipperId,
      this.custShipperRating,
      required this.deliveryFee,
      this.totalPrice,
      DateTime? orderDatetime,
      this.note = '',
      this.custResRating,
      this.reason = '',
      required this.custStatus,
      this.driverStatus,
      this.restStatus,
      this.orderItems = const [],
      this.restAddress,
      this.restLat,
      this.restLng,
      this.custAddress,
      this.custLat,
      this.custLng,
      this.restProvinceId,
      this.restDistrictId,
      this.restCommuneId,
      this.driverName,
      this.driverPhone,
      this.driverLicensePlate,
      this.driverProfileUrl,
      this.custResRatingComment,
      this.custShipperRatingComment,
      this.paymentMethod,
      this.paymentStatus,
      required this.customerId,
      this.shipperLat,
      this.shipperLng,
      this.createdAt})
      : orderDatetime = orderDatetime ?? DateTime.now();

  // Convert an Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'restaurantName': restaurantName,
      'restDetailAddress': restDetailAddress,
      'assignedShipperId': assignedShipperId,
      'custShipperRating': custShipperRating,
      'deliveryFee': deliveryFee,
      'orderDatetime': orderDatetime.toUtcIsoString,
      'note': note,
      'custResRating': custResRating,
      'reason': reason,
      'custStatus': custStatus,
      'driverStatus': driverStatus,
      'restStatus': restStatus,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'restAddress': restAddress,
      'custAddress': custAddress,
      'restProvinceId': restProvinceId,
      'restDistrictId': restDistrictId,
      'restCommuneId': restCommuneId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverLicensePlate': driverLicensePlate,
      'driverProfileUrl': driverProfileUrl,
      'custShipperRatingComment': custShipperRatingComment,
      'custResRatingComment': custResRatingComment,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'customerId': customerId,
      'shipperLat': shipperLat,
      'shipperLng': shipperLng,
      'restLat': restLat,
      'restLng': restLng,
      'custLat': custLat,
      'custLng': custLng,
    };
  }

  // Factory constructor to create an Order object from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: (json['_id'] == null) ? json['id'] : json['_id'],
        customerName: json['customerName'] ?? '',
        custPhone: json['custPhone'] ?? '',
        restaurantName: json['restaurantName'] ?? '',
        restaurantId: json['restaurantId'] ?? '',
        restDetailAddress: json['restDetailAddress'] ?? '',
        assignedShipperId: json['assignedShipperId'] ?? '',
        custShipperRating: json['custShipperRating'] != null
            ? (json['custShipperRating'] as num).toDouble()
            : null,
        deliveryFee: (json['deliveryFee'] as num).toInt(),
        totalPrice: (json['totalPrice'] as num).toInt(),
        orderDatetime: DateTime.parse(json['orderDatetime']),
        note: json['note'] ?? '',
        custResRating: json['custResRating'] != null
            ? (json['custResRating'] as num).toDouble()
            : null,
        reason: json['reason'] ?? '',
        custStatus: json['custStatus'] ?? 'waiting',
        driverStatus: json['driverStatus'],
        restStatus: json['restStatus'],
        orderItems: (json['orderItems'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
        restAddress: json['restAddress'], // Parse the restAddress field
        custAddress: json['custAddress'], // Parse the custAddress field
        restProvinceId: json['restProvinceId'], // Parse the new field
        restDistrictId: json['restDistrictId'], // Parse the new field
        restCommuneId: json['restCommuneId'], // Parse the new field
        driverName: json['driverName'] ?? 'Unknow',
        driverPhone: json['driverPhone'],
        driverLicensePlate: json['driverLicensePlate'],
        driverProfileUrl: json['driverProfileUrl'],
        custResRatingComment: json['custResRatingComment'],
        custShipperRatingComment: json['custShipperRatingComment'],
        paymentMethod: json['paymentMethod'] ?? 'Cash',
        paymentStatus: json['paymentStatus'] ?? 'pending',
        customerId: json['customerId'] ?? '',
        shipperLat: json['shipperLatitude'] != null
            ? (json['shipperLatitude'] as num).toDouble()
            : null,
        shipperLng: json['shipperLongitude'] != null
            ? (json['shipperLongitude'] as num).toDouble()
            : null,
        restLat: json['restLatitude'] != null
            ? (json['restLatitude'] as num).toDouble()
            : null,
        restLng: json['restLongitude'] != null
            ? (json['restLongitude'] as num).toDouble()
            : null,
        custLat: json['custLatitude'] != null
            ? (json['custLatitude'] as num).toDouble()
            : null,
        custLng: json['custLongitude'] != null
            ? (json['custLongitude'] as num).toDouble()
            : null,
        createdAt: json['createAt'] as DateTime?);
  }

  @override
  String toString() {
    return 'Order('
        'id: $id, '
        'customerName: $customerName, '
        'restaurantName: $restaurantName, '
        'restaurantId: $restaurantId, '
        'assignedShipperId: $assignedShipperId, '
        'custShipperRating: $custShipperRating, '
        'deliveryFee: $deliveryFee, '
        'orderDatetime: $orderDatetime, '
        'note: $note, '
        'custResRating: $custResRating, '
        'reason: $reason, '
        'custStatus: $custStatus, '
        'driverStatus: $driverStatus, '
        'restStatus: $restStatus, '
        'orderItems: $orderItems, '
        'restAddress: $restAddress, '
        'custAddress: $custAddress, '
        'restProvinceId: $restProvinceId, '
        'restDistrictId: $restDistrictId, '
        'restCommuneId: $restCommuneId, '
        'driverName: $driverName, '
        'driverPhone: $driverPhone, '
        'driverLicensePlate: $driverLicensePlate, '
        'driverProfileUrl: $driverProfileUrl, '
        'custShipperRatingComment: $custShipperRatingComment, '
        'custResRatingComment: $custResRatingComment, '
        'paymentMethod: $paymentMethod, '
        'paymentStatus: $paymentStatus, '
        'customerId: $customerId, '
        'shipperLat: $shipperLat, '
        'shipperLng: $shipperLng, '
        ')';
  }

  int getToTalPrice() {
    int result = 0;
    for (var x in orderItems) {
      result += x.totalPrice;
    }
    return result;
  }

  Order copyWith({
    String? id,
    String? customerName,
    String? restaurantName,
    String? restaurantId,
    String? restDetailAddress,
    String? assignedShipperId,
    double? custShipperRating,
    int? deliveryFee,
    DateTime? orderDatetime,
    String? note,
    double? custResRating,
    String? reason,
    String? custStatus,
    String? driverStatus,
    String? restStatus,
    List<OrderItem>? orderItems,
    String? restAddress,
    double? restLat,
    double? restLng,
    String? custAddress,
    double? custLat,
    double? custLng,
    String? custPhone,
    int? totalPrice,
    String? driverName,
    String? driverPhone,
    String? driverLicensePlate,
    String? driverProfileUrl,
    String? restProvinceId,
    String? restDistrictId,
    String? restCommuneId,
    String? custResRatingComment,
    String? custShipperRatingComment,
    String? paymentMethod,
    String? paymentStatus,
    String? customerId,
    double? shipperLat,
    double? shipperLng,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantId: restaurantId ?? this.restaurantId,
      restDetailAddress: restDetailAddress ?? this.restDetailAddress,
      assignedShipperId: assignedShipperId ?? this.assignedShipperId,
      custShipperRating: custShipperRating ?? this.custShipperRating,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      orderDatetime: orderDatetime ?? this.orderDatetime,
      note: note ?? this.note,
      custResRating: custResRating ?? this.custResRating,
      reason: reason ?? this.reason,
      custStatus: custStatus ?? this.custStatus,
      driverStatus: driverStatus ?? this.driverStatus,
      restStatus: restStatus ?? this.restStatus,
      orderItems: orderItems ?? this.orderItems,
      restAddress: restAddress ?? this.restAddress,
      restLat: restLat ?? this.restLat,
      custAddress: custAddress ?? this.custAddress,
      custLat: custLat ?? this.custLat,
      custLng: custLng ?? this.custLng,
      custPhone: custPhone ?? this.custPhone,
      totalPrice: totalPrice ?? this.totalPrice,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverLicensePlate: driverLicensePlate ?? this.driverLicensePlate,
      driverProfileUrl: driverProfileUrl ?? this.driverProfileUrl,
      restProvinceId: restProvinceId ?? this.restProvinceId,
      restDistrictId: restDistrictId ?? this.restDistrictId,
      restCommuneId: restCommuneId ?? this.restCommuneId,
      custResRatingComment: custResRatingComment ?? this.custResRatingComment,
      custShipperRatingComment:
          custShipperRatingComment ?? this.custShipperRatingComment,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      customerId: customerId ?? this.customerId,
      shipperLat: shipperLat ?? this.shipperLat,
      shipperLng: shipperLng ?? this.shipperLng,
    );
  }
}
