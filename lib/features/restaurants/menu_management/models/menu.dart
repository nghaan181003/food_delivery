import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';

class UpdatedCategory {
  String categoryId;
  String restaurantId;
  String categoryName;
  List<Item> items;

  UpdatedCategory(
      {this.categoryId = '',
      this.restaurantId = '',
      this.categoryName = '',
      this.items = const []});

  factory UpdatedCategory.fromJson(Map<String, dynamic> json) {
    return UpdatedCategory(
      categoryId: json['_id'] ?? '',
      restaurantId: json['partnerId'] ?? '',
      categoryName: json['name'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((itemJson) => Item.fromJson(itemJson))
              .toList() ??
          [],
    );
  }
}
