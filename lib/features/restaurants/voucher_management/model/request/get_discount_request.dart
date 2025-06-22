import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';

class GetVoucherRequest {
  final String partnerId;
  final VoucherStatus status;

  GetVoucherRequest({required this.partnerId, this.status = VoucherStatus.all});

  Map<String, dynamic> toJson() {
    return {
      'shopId': partnerId,
      if (status != VoucherStatus.all) 'status': status.toDbText
    };
  }
}
