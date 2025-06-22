class ItemModel {
  final String id;
  final String categoryId;
  final String partnerId;
  final String itemName;
  final int price;
  final String description;
  final bool status;
  final String itemImage;
  final String normalizedItemName;

  ItemModel({
    required this.id,
    required this.categoryId,
    required this.partnerId,
    required this.itemName,
    required this.price, 
    required this.description,
    required this.status,
    required this.itemImage,
    required this.normalizedItemName,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['_id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      partnerId: json['partnerId'] ?? '',
      itemName: json['itemName'] ?? '',
      price: (json['price'] ?? 0).toInt(), 
      description: json['description'] ?? '',
      status: json['status'] ?? false, 
      itemImage: json['itemImage'] ?? '',
      normalizedItemName: json['normalizedItemName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryId': categoryId,
      'partnerId': partnerId,
      'itemName': itemName,
      'price': price, 
      'description': description,
      'status': status,
      'itemImage': itemImage,
      'normalizedItemName': normalizedItemName,
    };
  }

}
