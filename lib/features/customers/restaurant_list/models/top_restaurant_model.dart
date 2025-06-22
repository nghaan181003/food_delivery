import 'dart:collection';

class TopRestaurantModel {
  final double averageRating;
  final int totalOrders;
  final String restaurantId;
  final String userName;
  final String restaurantURL;
  final double? distance;
  final String? detailAddress;

  // Constructor to initialize the fields
  TopRestaurantModel({
    required this.averageRating,
    required this.totalOrders,
    required this.restaurantId,
    required this.userName,
    required this.restaurantURL,
    this.distance,
    this.detailAddress,
  });

  // Factory constructor to create RestaurantRatingModel from JSON data
  factory TopRestaurantModel.fromJson(Map<String, dynamic> json) {
    return TopRestaurantModel(
      averageRating: json['averageRating']?.toDouble() ?? 0.0,
      totalOrders: json['totalOrders'] ?? 0,
      restaurantId: json['restaurantId'] ?? '',
      userName: json['userName'] ?? 'Unknown',
      restaurantURL: json['restaurantURL'] ?? '',
    );
  }

  factory TopRestaurantModel.fromJsonForNearby(Map<String, dynamic> json) {
    return TopRestaurantModel(
      averageRating: json['averageRating']?.toDouble() ?? 0.0,
      totalOrders: json['totalOrders'] ?? 0,
      restaurantId: json['_id'] ?? '',
      userName: json['userId']['name'] ?? 'Unknown',
      restaurantURL: json['avatarUrl'] ?? '',
      distance: json['distance'] ?? 0,
      detailAddress: json['detailAddress'] ?? '',
    );
  }

  // Method to convert the RestaurantRatingModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalOrders': totalOrders,
      'restaurantId': restaurantId,
      'userName': userName,
      'restaurantURL': restaurantURL,
    };
  }
}
