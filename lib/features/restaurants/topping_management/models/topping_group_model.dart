import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';

class ToppingGroupModel {
  final String? id;
  final String name;
  final String shopId;
  final bool isRequired;
  final int maxSelect;
  final List<ToppingModel> toppings;

  ToppingGroupModel(
      {this.id,
      this.name = "",
      this.toppings = const [],
      this.shopId = "",
      this.isRequired = false,
      this.maxSelect = 1});

  ToppingGroupModel copyWith(
      {String? id,
      String? name,
      List<ToppingModel>? toppings,
      String? shopId,
      bool? isRequired,
      int? maxSelect}) {
    return ToppingGroupModel(
        id: id ?? this.id,
        name: name ?? this.name,
        shopId: shopId ?? this.shopId,
        toppings: toppings ?? this.toppings,
        isRequired: isRequired ?? this.isRequired,
        maxSelect: maxSelect ?? this.maxSelect);
  }

  int get quantity => toppings.length;

  int get isActiveQuantity => toppings.where((e) => e.isActive == true).length;

  String get toppingCounter => "$isActiveQuantity/$quantity";

  String get toppingNames =>
      quantity > 0 ? toppings.map((e) => e.name).join(', ') : "Chưa có topping";

  bool get isNew => id == null;

  factory ToppingGroupModel.fromJson(Map<String, dynamic> json) {
    return ToppingGroupModel(
      id: json["_id"],
      name: json["tpGroupName"] ?? "",
      isRequired: json["isRequired"] ?? false,
      maxSelect: json["maxSelect"] ?? 1,
      toppings: (json["toppings"] as List<dynamic>? ?? [])
          .map((item) => ToppingModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tpGroupName": name,
      "tpShopId": shopId,
      "isRequired": isRequired,
      "maxSelect": maxSelect,
      "toppings": toppings.map((e) => e.toJson()).toList()
    };
  }
}
