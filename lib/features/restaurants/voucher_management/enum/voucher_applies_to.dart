import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/options_widget.dart';

enum VoucherAppliesTo { specific, all }

extension ToppingGroupOptionX on VoucherAppliesTo {
  Widget toWidget(
          {required VoucherAppliesTo groupValue,
          Function(VoucherAppliesTo?)? onChanged}) =>
      switch (this) {
        VoucherAppliesTo.all => OptionsWidget<VoucherAppliesTo>(
            groupValue: groupValue,
            value: VoucherAppliesTo.all,
            label: "Có",
            onChanged: onChanged,
            isReverse: true,
          ),
        VoucherAppliesTo.specific => OptionsWidget<VoucherAppliesTo>(
            groupValue: groupValue,
            value: VoucherAppliesTo.specific,
            label: "Không",
            onChanged: onChanged,
            isReverse: true,
          )
      };
  bool get isAll => this == VoucherAppliesTo.all;
  bool get isSpecific => this == VoucherAppliesTo.specific;

  String get toDbText => switch (this) {
        VoucherAppliesTo.specific => "specific",
        VoucherAppliesTo.all => "all"
      };

  String get toEntityString => switch (this) {
        VoucherAppliesTo.specific => "Các món đã chọn",
        VoucherAppliesTo.all => "Tất cả"
      };
}
