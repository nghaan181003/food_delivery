class TopItemModel {
  final String id;          // _id field
  final String partnerId;   // partnerId field
  final String itemName;    // itemName field
  final double price;       // price field
  final String description; // description field
  final String itemImage;   // itemImage field
  final int sales;          // sales field

  // Constructor to initialize the fields
  TopItemModel({
    required this.id,
    required this.partnerId,
    required this.itemName,
    required this.price,
    required this.description,
    required this.itemImage,
    required this.sales,
  });

  // Factory constructor to create MenuItemModel from JSON data
  factory TopItemModel.fromJson(Map<String, dynamic> json) {
    return TopItemModel(
      id: json['_id'] ?? '',
      partnerId: json['partnerId'] ?? '',
      itemName: json['itemName'] ?? '',
      price: json['price']?.toDouble() ?? 0.0, // Ensuring the price is a double
      description: json['description'] ?? '',
      itemImage: json['itemImage'] ?? '',
      sales: int.tryParse(json['sales']?.toString() ?? '0') ?? 0, // Parsing sales as integer
    );
  }

  // Method to convert the MenuItemModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'partnerId': partnerId,
      'itemName': itemName,
      'price': price,
      'description': description,
      'itemImage': itemImage,
      'sales': sales,
    };
  }
}
