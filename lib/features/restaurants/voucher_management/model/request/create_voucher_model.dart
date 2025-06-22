import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_type.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';

class CreateVoucherModel {
  final String? id;
  final String? shopId;
  final String? name;
  final String? code;
  final VoucherType type;
  final num? value;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoucherStatus? status;
  final VoucherAppliesTo appliesTo;
  final List<String> productIdx;
  final bool isPublic;
  final num? maxUsersPerUser;
  final num? minOrdervalue;
  final num? quantity;
  final num? usedCount;
  final List<String>? usersIdx;

  CreateVoucherModel({
    this.id,
    this.code,
    this.shopId,
    this.name,
    this.type = VoucherType.percentage,
    this.status,
    this.quantity,
    this.value,
    this.startDate,
    this.endDate,
    this.appliesTo = VoucherAppliesTo.all,
    this.isPublic = false,
    this.usedCount,
    this.minOrdervalue,
    this.productIdx = const [],
    this.usersIdx,
    this.maxUsersPerUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'voucher_shop_id': shopId,
      'voucher_name': name,
      'voucher_code': code,
      'voucher_id': id,
      'voucher_type': type.toDbText,
      if (status != null) 'voucher_status': status!.toDbText,
      if (startDate != null) 'voucher_start_date': startDate!.toUtcIsoString,
      if (endDate != null) 'voucher_end_date': endDate!.toUtcIsoString,
      'voucher_applies_to': appliesTo.toDbText,
      'voucher_products_idx': productIdx.map((e) => e.toString()).toList(),
      'voucher_value': value,
      'voucher_is_public': isPublic,
      'voucher_max_users_per_user': maxUsersPerUser,
      'voucher_min_order_value': minOrdervalue,
      'voucher_quantity': quantity,
      if (usersIdx != null)
        'voucher_users_idx': usersIdx!.map((e) => e.toString()).toList(),
    };
  }
}
