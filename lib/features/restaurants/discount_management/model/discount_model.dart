/* 
{
    "discount_shop_id": "6749d1a1214ecac2cd6094ef", // ID cửa hàng
    "discount_name": "Giảm giá mùa hè", // Tên chương trình giảm giá
    "discount_type": "percentage", // Loại giảm giá: "percentage" hoặc "fixed"
    "discount_value": 20, // Giá trị giảm giá (nếu là percentage thì max 100)
    "discount_start_date": "2025-05-10T00:00:00.000Z", // Ngày bắt đầu (ISO 8601 format)
    "discount_end_date": "2025-06-16T23:59:59.000Z", // Ngày kết thúc
    "discount_status": "running", // Trạng thái: "scheduled", "running", hoặc "expired"
    "discount_min_order_value": 100000, // (Optional) Giá trị đơn hàng tối thiểu
    "discount_applies_to": "specific", // "all" (tất cả sản phẩm) hoặc "specific" (sản phẩm cụ thể)
    "discount_products_idx": [
        "6749d312214ecac2cd60952b",
        "6749d3c5214ecac2cd609541"
    ], // (Bắt buộc nếu applies_to là "specific") Mảng ID sản phẩm
    "discount_max_items_per_order": 5, // (Optional) Số lượng sản phẩm tối đa mỗi đơn hàng
    "discount_max_quantity_per_item_per_order": 2, // (Optional) Số lượng tối đa mỗi sản phẩm trong đơn hàng
    "discount_max_quantity_per_item_per_day": 3, // (Optional) Số lượng mỗi sản phẩm mỗi ngày
    "discount_item_per_order": 3, // (Optional) Tổng số sản phẩm được giảm giá trong một đơn
    "discount_max_quantity_per_item_per_user_per_day": 1 // (Optional) Số lượng tối đa mỗi người dùng/ngày/sản phẩm
}
*/

import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/dicount_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_type.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:food_delivery_h2d/utils/extension/string_extension.dart';

class DiscountModel {
  final String? id;
  final String? shopId;
  final String? name;
  final DiscountType type;
  final num? value;
  final DateTime startDate;
  final DateTime endDate;
  final DiscountStatus? status;
  final DiscountAppliesTo appliesTo;
  final List<String> productIdx;

  DiscountModel(
      {this.id,
      this.shopId,
      this.name,
      this.type = DiscountType.percentage,
      this.status,
      this.value,
      required this.startDate,
      required this.endDate,
      this.appliesTo = DiscountAppliesTo.all,
      this.productIdx = const []});

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
        id: json["_id"],
        shopId: json['discount_shop_id'],
        name: json['discount_name'],
        type: (json['discount_type'] as String).fromDiscountTypeDbText,
        status: (json['discount_status'] as String).fromDiscountStatusDbText,
        value: json['discount_value'],
        startDate: DateTime.parse(json['discount_start_date']).toLocal(),
        endDate: DateTime.parse(json['discount_end_date']).toLocal(),
        productIdx: (json['discount_products_idx'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        appliesTo: (json["discount_applies_to"] as String)
            .fromDiscountAppliesToDbText);
  }

  Map<String, dynamic> toJson() {
    return {
      'discount_shop_id': shopId,
      'discount_name': name,
      'discount_type': type.toDbText,
      if (status != null) 'discount_status': status!.toDbText,
      'discount_start_date': startDate.toUtcIsoString,
      'discount_end_date': endDate.toUtcIsoString,
      'discount_applies_to': appliesTo.toDbText,
      'discount_products_idx': productIdx.map((e) => e.toString()).toList(),
      'discount_value': value
    };
  }

  DiscountModel copyWith({
    String? id,
    String? shopId,
    String? name,
    DiscountType? type,
    num? value,
    DateTime? startDate,
    DateTime? endDate,
    DiscountStatus? status,
    DiscountAppliesTo? appliesTo,
    List<String>? productIdx,
  }) {
    return DiscountModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      appliesTo: appliesTo ?? this.appliesTo,
      productIdx: productIdx ?? List.from(this.productIdx),
    );
  }
}
