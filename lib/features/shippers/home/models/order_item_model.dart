import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';

class OrderItem {
  String itemId;
  String itemName;
  int quantity;
  int price;
  int totalPrice;
  String foodId;
  List<ToppingModel> toppings;

  OrderItem(
      {required this.itemId,
      required this.foodId,
      required this.itemName,
      required this.quantity,
      required this.price,
      required this.totalPrice,
      this.toppings = const []});

  // Convert OrderItem object to JSON
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'toppings': toppings.map((e) => e.toJson()).toList()
    };
  }

  // Factory constructor to create an OrderItem from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        itemId: json['id'] ?? '',
        itemName: json['itemName'] ?? 'Unknow',
        quantity: json['quantity'] ?? 0,
        price: (json['price'] as num).toInt(),
        totalPrice: (json['totalPrice'] as num).toInt(),
        foodId: json['foodId'] ?? '',
        toppings: ((json['toppings'] ?? []) as List)
            .map((i) => ToppingModel.fromJson(i))
            .toList());
  }

  @override
  String toString() {
    return 'OrderItem('
        'itemId: $itemId, '
        'itemName: $itemName, '
        'quantity: $quantity, '
        'price: $price, '
        'totalPrice: $totalPrice'
        ')';
  }
}
