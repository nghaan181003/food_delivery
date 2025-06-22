import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_type.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/request/create_voucher_model.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_customer.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:food_delivery_h2d/utils/extension/string_extension.dart';

import 'package:food_delivery_h2d/utils/formatter/currency.dart';

class VoucherModel {
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
  final String? shopName;
  final List<VoucherCustomer>? customers;

  VoucherModel(
      {this.id,
      this.code,
      this.shopId,
      this.name,
      this.shopName,
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
      this.customers,
      this.maxUsersPerUser});

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json["_id"],
      code: json['voucher_code'],
      shopId: json['voucher_shop_id'],
      name: json['voucher_name'],
      type: (json['voucher_type'] as String).fromVoucherTypeDbText,
      status: (json['voucher_status'] as String).fromVoucherStatusDbText,
      value: json['voucher_value'],
      startDate: DateTime.parse(json['voucher_start_date']).toLocal(),
      endDate: DateTime.parse(json['voucher_end_date']).toLocal(),
      productIdx: (json['voucher_products_idx'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      appliesTo:
          (json["voucher_applies_to"] as String).fromVoucherAppliesToDbText,
      isPublic: json['voucher_is_public'],
      customers: json['customers'] != null
          ? (json['customers'] as List<dynamic>)
              .map((e) => VoucherCustomer.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      usedCount: json['voucher_used_count'],
      quantity: json['voucher_quantity'],
      maxUsersPerUser: json['voucher_max_users_per_user'],
      minOrdervalue: json['voucher_min_order_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voucher_shop_id': shopId,
      'voucher_name': name,
      'voucher_type': type.toDbText,
      if (status != null) 'voucher_status': status!.toDbText,
      if (startDate != null) 'voucher_start_date': startDate!.toUtcIsoString,
      if (endDate != null) 'voucher_end_date': endDate!.toUtcIsoString,
      'voucher_applies_to': appliesTo.toDbText,
      'voucher_products_idx': productIdx.map((e) => e.toString()).toList(),
      'voucher_value': value
    };
  }

  VoucherModel copyWith({
    String? id,
    String? shopId,
    String? name,
    String? code,
    VoucherType? type,
    num? value,
    DateTime? startDate,
    DateTime? endDate,
    VoucherStatus? status,
    VoucherAppliesTo? appliesTo,
    List<String>? productIdx,
    bool? isPublic,
    num? maxUsersPerUser,
    num? minOrdervalue,
    num? quantity,
    num? usedCount,
    List<VoucherCustomer>? customers,
  }) {
    return VoucherModel(
      id: id ?? this.id,
      code: code ?? this.code,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      value: value ?? this.value,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      appliesTo: appliesTo ?? this.appliesTo,
      isPublic: isPublic ?? this.isPublic,
      usedCount: usedCount ?? this.usedCount,
      minOrdervalue: minOrdervalue ?? this.minOrdervalue,
      productIdx: productIdx ?? this.productIdx,
      customers: customers ?? this.customers,
      maxUsersPerUser: maxUsersPerUser ?? this.maxUsersPerUser,
    );
  }

  CreateVoucherModel get toCreateVoucherModel {
    return CreateVoucherModel(
      id: id,
      code: code,
      shopId: shopId,
      name: name,
      type: type,
      status: status,
      quantity: quantity,
      value: value,
      startDate: startDate,
      endDate: endDate,
      appliesTo: appliesTo,
      isPublic: isPublic,
      usedCount: usedCount,
      minOrdervalue: minOrdervalue,
      productIdx: productIdx,
      usersIdx: customers?.map((e) => e.customerId).toList(),
      maxUsersPerUser: maxUsersPerUser,
    );
  }

  String get formattedValue => value != null
      ? 'Giảm ${value?.formatCurrencyNoSymbol}${type == VoucherType.percentage ? '%' : 'đ'}'
      : '';

  num discountPrice(num totalPrice) {
    if (type == VoucherType.percentage) {
      return (totalPrice * value! / 100);
    } else {
      return (value ?? 0);
    }
  }

  bool get isShowActions => status == VoucherStatus.scheduled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoucherModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
