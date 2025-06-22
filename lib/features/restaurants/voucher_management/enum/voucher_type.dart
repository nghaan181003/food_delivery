import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/options_widget.dart';

enum VoucherType {
  percentage,
  fixed,
}

extension DiscountTypeX on VoucherType {
  String get toDbText => switch (this) {
        VoucherType.fixed => 'fixed',
        VoucherType.percentage => 'percentage',
      };

  Widget toWidget(
          {required VoucherType groupValue,
          Function(VoucherType?)? onChanged}) =>
      switch (this) {
        VoucherType.fixed => OptionsWidget<VoucherType>(
            groupValue: groupValue,
            value: VoucherType.fixed,
            label: "Giá trị cố định",
            onChanged: onChanged,
            isReverse: true,
          ),
        VoucherType.percentage => OptionsWidget<VoucherType>(
            groupValue: groupValue,
            value: VoucherType.percentage,
            label: "Phần trăm",
            onChanged: onChanged,
            isReverse: true,
          )
      };

  String get toEntityString => switch (this) {
        VoucherType.fixed => "Đồng giá",
        VoucherType.percentage => "Phần trăm"
      };

  bool get isFixed => this == VoucherType.fixed;
  bool get ispercentage => this == VoucherType.percentage;
}
