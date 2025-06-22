import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/options_widget.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_type.dart';

enum VoucherPublic { yes, no }

extension VoucherPublicExtension on VoucherPublic {
  bool get toDbBool => switch (this) {
        VoucherPublic.yes => true,
        VoucherPublic.no => false,
      };

  Widget toWidget(
          {required VoucherPublic groupValue,
          Function(VoucherPublic?)? onChanged}) =>
      switch (this) {
        VoucherPublic.yes => OptionsWidget<VoucherPublic>(
            groupValue: groupValue,
            value: VoucherPublic.yes,
            label: "Công khai",
            onChanged: onChanged,
            isReverse: true,
          ),
        VoucherPublic.no => OptionsWidget<VoucherPublic>(
            groupValue: groupValue,
            value: VoucherPublic.no,
            label: "Riêng tư",
            onChanged: onChanged,
            isReverse: true,
          )
      };
}
