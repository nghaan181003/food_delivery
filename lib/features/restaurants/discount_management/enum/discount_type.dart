import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/options_widget.dart';

enum DiscountType {
  percentage,
  fixed,
}

extension DiscountTypeX on DiscountType {
  String get toDbText => switch (this) {
        DiscountType.fixed => 'fixed',
        DiscountType.percentage => 'percentage',
      };

  Widget toWidget(
          {required DiscountType groupValue,
          Function(DiscountType?)? onChanged}) =>
      switch (this) {
        DiscountType.fixed => OptionsWidget<DiscountType>(
            groupValue: groupValue,
            value: DiscountType.fixed,
            label: "Đồng giá",
            onChanged: onChanged,
            isReverse: true,
          ),
        DiscountType.percentage => OptionsWidget<DiscountType>(
            groupValue: groupValue,
            value: DiscountType.percentage,
            label: "Phần trăm",
            onChanged: onChanged,
            isReverse: true,
          )
      };

  String get toEntityString => switch (this) {
        DiscountType.fixed => "Đồng giá",
        DiscountType.percentage => "Phần trăm"
      };

 
  bool get isFixed => this == DiscountType.fixed;
  bool get ispercentage => this == DiscountType.percentage;
}
