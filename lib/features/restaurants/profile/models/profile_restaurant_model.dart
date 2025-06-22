import 'package:get/get.dart';

class ProfileRestaurant {
  int restaurantId;
  DateTime joinDate;
  String name;
  String phoneNumber;
  String email;
  String address;
  String description;
  RxBool isAvailable;

  // New image fields
  String avatarUrl;
  String storeFront;
  String CCCDFrontUrl;
  String CCCDBackUrl;

  ProfileRestaurant({
    this.restaurantId = 0,
    DateTime? joinDate,
    this.name = '',
    this.phoneNumber = '',
    this.email = '',
    this.address = '',
    this.description = '',
    bool? isAvailable,
    this.avatarUrl = '',
    this.storeFront = '',
    this.CCCDFrontUrl = '',
    this.CCCDBackUrl = '',
  })  : joinDate = joinDate ?? DateTime.now(),
        isAvailable = (isAvailable ?? false).obs;

  factory ProfileRestaurant.fromJson(Map<String, dynamic> json) {
    return ProfileRestaurant(
      restaurantId: json['restaurantId'] ?? 0,
      joinDate: DateTime.tryParse(json['joinDate'] ?? '') ?? DateTime.now(),
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      avatarUrl: json['avatarUrl'] ?? '',
      storeFront: json['storeFront'] ?? '',
      CCCDFrontUrl: json['CCCDFrontUrl'] ?? '',
      CCCDBackUrl: json['CCCDBackUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'joinDate': joinDate.toIso8601String(),
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'description': description,
      'isAvailable': isAvailable.value,
      'avatarUrl': avatarUrl,
      'storeFront': storeFront,
      'CCCDFrontUrl': CCCDFrontUrl,
      'CCCDBackUrl': CCCDBackUrl,
    };
  }
}
