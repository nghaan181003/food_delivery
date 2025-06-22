import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProfileRestaurant {
  int restaurantId;
  DateTime joinDate;
  String restaurantName;
  String phoneNumber;
  String email;
  String address;
  String description;
  RxBool isAvailable;

  ProfileRestaurant({
    this.restaurantId = 0,
    DateTime? joinDate,
    this.restaurantName = '',
    this.phoneNumber = '',
    this.email = '',
    this.address = '',
    this.description = '',
    bool? isAvailable,
  }) : joinDate = joinDate ?? DateTime.now(),
   isAvailable = (isAvailable ?? true).obs;
}
