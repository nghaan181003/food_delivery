import 'dart:ui';

import 'package:food_delivery_h2d/utils/constants/colors.dart';

enum VoucherStatus { all, running, scheduled, finished, canceled }

extension VoucherStatusExt on VoucherStatus {
  String? get toDbText => switch (this) {
        VoucherStatus.scheduled => "scheduled",
        VoucherStatus.running => 'running',
        VoucherStatus.finished => 'finished',
        VoucherStatus.all => null,
        VoucherStatus.canceled => 'canceled'
      };

  String get toEntityString => switch (this) {
        VoucherStatus.scheduled => "Sắp diễn ra",
        VoucherStatus.running => 'Đang diễn ra',
        VoucherStatus.finished => 'Kết thúc',
        VoucherStatus.all => 'Tất cả',
        VoucherStatus.canceled => "Đã hủy"
      };

  Color get toColor => switch (this) {
        VoucherStatus.scheduled => MyColors.warningColor,
        VoucherStatus.running => MyColors.successColor,
        VoucherStatus.finished => MyColors.closeColor,
        VoucherStatus.all => MyColors.successColor,
        VoucherStatus.canceled => MyColors.errorColor
      };
}
