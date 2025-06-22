import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/dicount_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_type.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_type.dart';

extension StringExt on String {
  DiscountType get fromDiscountTypeDbText => switch (toLowerCase()) {
        "percentage" => DiscountType.percentage,
        "fixed" => DiscountType.fixed,
        _ => DiscountType.percentage,
      };

  DiscountStatus get fromDiscountStatusDbText => switch (toLowerCase()) {
        "scheduled" => DiscountStatus.scheduled,
        "running" => DiscountStatus.running,
        "finished" => DiscountStatus.finished,
        'canceled' => DiscountStatus.canceled,
        _ => DiscountStatus.scheduled,
      };

  DiscountAppliesTo get fromDiscountAppliesToDbText => switch (toLowerCase()) {
        "specific" => DiscountAppliesTo.specific,
        "all" => DiscountAppliesTo.all,
        _ => DiscountAppliesTo.all
      };

  VoucherType get fromVoucherTypeDbText => switch (toLowerCase()) {
        "percentage" => VoucherType.percentage,
        "fixed" => VoucherType.fixed,
        _ => VoucherType.percentage,
      };

  VoucherStatus get fromVoucherStatusDbText => switch (toLowerCase()) {
        "scheduled" => VoucherStatus.scheduled,
        "running" => VoucherStatus.running,
        "finished" => VoucherStatus.finished,
        'canceled' => VoucherStatus.canceled,
        _ => VoucherStatus.scheduled,
      };

  VoucherAppliesTo get fromVoucherAppliesToDbText => switch (toLowerCase()) {
        "specific" => VoucherAppliesTo.specific,
        "all" => VoucherAppliesTo.all,
        _ => VoucherAppliesTo.all
      };
}
