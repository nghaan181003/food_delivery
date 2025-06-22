class Category {
  String categoryId;
  String restaurantId;
  String categoryName;

  Category({
    this.categoryId = '',
    this.restaurantId = '',
    this.categoryName = '',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        categoryId: json['_id'],
        restaurantId: json['partnerId'],
        categoryName: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': categoryId, 'name': categoryName, 'partnerId': restaurantId};
  }
}
