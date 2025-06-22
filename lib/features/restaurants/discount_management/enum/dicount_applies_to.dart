import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/options_widget.dart';

enum DiscountAppliesTo { specific, all }

extension ToppingGroupOptionX on DiscountAppliesTo {
  Widget toWidget(
          {required DiscountAppliesTo groupValue,
          Function(DiscountAppliesTo?)? onChanged}) =>
      switch (this) {
        DiscountAppliesTo.all => OptionsWidget<DiscountAppliesTo>(
            groupValue: groupValue,
            value: DiscountAppliesTo.all,
            label: "Có",
            onChanged: onChanged,
            isReverse: true,
          ),
        DiscountAppliesTo.specific => OptionsWidget<DiscountAppliesTo>(
            groupValue: groupValue,
            value: DiscountAppliesTo.specific,
            label: "Không",
            onChanged: onChanged,
            isReverse: true,
          )
      };
  bool get isAll => this == DiscountAppliesTo.all;
  bool get isSpecific => this == DiscountAppliesTo.specific;

  String get toDbText => switch (this) {
        DiscountAppliesTo.specific => "specific",
        DiscountAppliesTo.all => "all"
      };

  String get toEntityString => switch (this) {
        DiscountAppliesTo.specific => "Các món đã chọn",
        DiscountAppliesTo.all => "Tất cả"
      };
}
