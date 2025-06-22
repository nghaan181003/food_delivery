import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';

class GetDiscountRequest {
  final String partnerId;
  final DiscountStatus status;

  GetDiscountRequest(
      {required this.partnerId, this.status = DiscountStatus.all});

  Map<String, dynamic> toJson() {
    return {'partnerId': partnerId, 'discountStatus': status.toDbText};
  }
}
