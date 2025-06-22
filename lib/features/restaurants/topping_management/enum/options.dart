import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/options_widget.dart';

enum ToppingGroupOptions {
  no,
  yes,
}

extension ToppingGroupOptionsX on ToppingGroupOptions {
  Widget toWidget(
          {required ToppingGroupOptions groupValue,
          Function(ToppingGroupOptions?)? onChanged}) =>
      switch (this) {
        ToppingGroupOptions.yes => OptionsWidget<ToppingGroupOptions>(
            groupValue: groupValue,
            value: ToppingGroupOptions.yes,
            label: "Bắt buộc với số lượng tùy chọn",
            onChanged: onChanged,
          ),
        ToppingGroupOptions.no => OptionsWidget<ToppingGroupOptions>(
            groupValue: groupValue,
            value: ToppingGroupOptions.no,
            label: "Không bắt buộc",
            onChanged: onChanged,
          )
      };
  bool get isYes => this == ToppingGroupOptions.yes;
  bool get isNo => this == ToppingGroupOptions.no;

  bool get toValue => switch (this) {
        ToppingGroupOptions.yes => true,
        ToppingGroupOptions.no => false,
      };
}
