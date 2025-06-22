import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:get/get.dart';
class TimeSlot {
  String open;
  String close;

  TimeSlot({required this.open, required this.close});

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        open: json['open'] ?? '',
        close: json['close'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'open': open,
        'close': close,
      };
}

class DaySchedule {
  String day;
  List<TimeSlot> timeSlots;

  DaySchedule({required this.day, required this.timeSlots});

  factory DaySchedule.fromJson(Map<String, dynamic> json) => DaySchedule(
        day: json['day'] ?? '',
        timeSlots: (json['timeSlots'] as List<dynamic>?)
                ?.map((e) => TimeSlot.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'timeSlots': timeSlots.map((e) => e.toJson()).toList(),
      };
}
class Item {
  String itemId;
  String categoryId;
  String partnerId;
  String itemName;
  int price;
  int quantity;
  int sales;
  String description;
  RxBool isAvailable;
  String itemImage;
  String keySearch;
  int? salePrice;
  final List<DaySchedule> schedule;

  final List<ToppingModel> selectedToppings;

  Item({
    this.itemId = '',
    this.categoryId = '',
    this.partnerId = '',
    this.itemName = '',
    this.keySearch = '',
    this.price = 0,
    this.sales = 0,
    this.salePrice,
    this.description = '',
    bool? isAvailable,
    this.itemImage = MyImagePaths.iconImage,
    this.quantity = 0,
    this.selectedToppings = const [],
    this.schedule = const [],
  }) : isAvailable = (isAvailable ?? true).obs;

  Map<String, dynamic> toJson() {
    return {
      '_id': itemId,
      'categoryId': categoryId,
      'itemName': itemName,
      'price': price.toString(),
      'description': description,
      'status': isAvailable.value.toString(),
      'itemImage': itemImage,
      'partnerId': partnerId,
      "quantity": quantity.toString(),
      "keySearch": keySearch,
      'schedule': schedule.map((e) => e.toJson()).toList(),
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        itemId: json['_id'] ?? '',
        categoryId: json['categoryId'] ?? '',
        partnerId: json['partnerId'] ?? '',
        itemName: json['itemName'] ?? '',
        price: json['price'] ?? 0,
        sales: json['sales'] ?? 0,
        description: json['description'] ?? '',
        isAvailable: json['status'] ?? true,
        itemImage: json['itemImage'] ?? MyImagePaths.iconImage,
        quantity: json['quantity'] ?? 0,
        keySearch: json['keySearch'] ?? "",
        salePrice: json['salePrice'],
        schedule: (json['schedule'] as List<dynamic>?)
              ?.map((e) => DaySchedule.fromJson(e))
              .toList() ??
          [],);
  }

  Item copyWith(
      {String? itemId,
      String? categoryId,
      String? partnerId,
      String? itemName,
      int? price,
      int? quantity,
      int? sales,
      String? description,
      String? itemImage,
      String? keySearch,
      List<ToppingModel>? selectedToppings,
      int? salePrice}) {
    return Item(
        itemId: itemId ?? this.itemId,
        categoryId: categoryId ?? this.categoryId,
        partnerId: partnerId ?? this.partnerId,
        itemName: itemName ?? this.itemName,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        sales: sales ?? this.sales,
        description: description ?? this.description,
        itemImage: itemImage ?? this.itemImage,
        keySearch: keySearch ?? this.keySearch,
        selectedToppings: selectedToppings ?? this.selectedToppings,
        salePrice: sales ?? this.salePrice);
  }

  @override
  String toString() {
    return 'Item('
        'itemId: $itemId, '
        'categoryId: $categoryId, '
        'partnerId: $partnerId, '
        'itemName: $itemName, '
        'price: $price, '
        'quantity: $quantity, '
        'description: $description, '
        'isAvailable: ${isAvailable.value}, '
        'itemImage: $itemImage'
        'toppngs : ${selectedToppings.length}'
        ')';
  }

  String getUniqueKey(Item item) {
    final toppings = item.selectedToppings.map((e) => e.id).toList()..sort();
    return '${item.itemId}_${toppings.join("_")}';
  }

  num get _totalToppingPrices =>
      selectedToppings.fold(0, (sum, topping) => sum + (topping.price ?? 0));

  num get totalItemPrice => (salePrice ?? price) + _totalToppingPrices;
}

extension ItemExt on Item {
  String get uniqueKey {
    final toppings = selectedToppings.map((e) => e.id).toList()..sort();
    return '${itemId}_${toppings.join("_")}';
  }
}
