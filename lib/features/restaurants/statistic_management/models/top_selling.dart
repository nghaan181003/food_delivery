class TopSellingItem {
  final String id;
  final String itemName;
  final int sales;
  final String itemImage;
  final int price;

  TopSellingItem({
    required this.id,
    required this.itemName,
    required this.sales,
    required this.itemImage,
    required this.price,
  });

  factory TopSellingItem.fromJson(Map<String, dynamic> json) {
    return TopSellingItem(
      id: json['_id'] ?? '',
      itemName: json['itemName'] ?? '',
      sales: json['sales'] ?? 0,
      itemImage: json['itemImage'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'itemName': itemName,
      'sales': sales,
      'itemImage': itemImage,
      'price': price,
    };
  }
}
