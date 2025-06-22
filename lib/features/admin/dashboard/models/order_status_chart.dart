class OrderStatusChartModel {
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;

  OrderStatusChartModel({
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
  });

  // Factory constructor to create a RestaurantRatingModel from JSON data
  factory OrderStatusChartModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusChartModel(
      totalOrders: json['totalOrders'] ?? 0,
      completedOrders: json['completedOrders'] ?? 0,
      cancelledOrders: json['cancelledOrders'] ?? 0,
    );
  }

  // Method to convert the RestaurantRatingModel object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'cancelledOrders': cancelledOrders,
    };
  }
}
