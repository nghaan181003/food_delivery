import 'dart:ui';

import 'package:food_delivery_h2d/features/restaurants/discount_management/view/create_discount_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';

enum DiscountStatus { all, scheduled, running, finished, canceled }

extension DiscountStatusExt on DiscountStatus {
  String get toDbText => switch (this) {
        DiscountStatus.scheduled => "scheduled",
        DiscountStatus.running => 'running',
        DiscountStatus.finished => 'finished',
        DiscountStatus.all => 'all',
        DiscountStatus.canceled => 'canceled'
      };

  String get toEntityString => switch (this) {
        DiscountStatus.scheduled => "Đã lên lịch",
        DiscountStatus.running => 'Đang chạy',
        DiscountStatus.finished => 'Kết thúc',
        DiscountStatus.all => 'Tất cả',
        DiscountStatus.canceled => "Đã hủy"
      };

  bool get isCanceled => this == DiscountStatus.canceled;
  bool get isFinished => this == DiscountStatus.finished;

  String toDuration({
    required DateTime now,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    switch (this) {
      case DiscountStatus.scheduled:
        if (now.isBefore(startTime)) {
          final duration = startTime.calculateDuration(now);

          return 'Bắt đầu sau $duration';
        }
        return 'Sắp bắt đầu';

      case DiscountStatus.running:
        if (now.isBefore(endTime)) {
          final duration = now.calculateDuration(endTime);
          return 'Còn lại $duration';
        }
        return 'Sắp kết thúc';

      case DiscountStatus.finished:
        if (now.isAfter(endTime)) {
          final duration = now.calculateDuration(endTime);
          return 'Đã kết thúc $duration trước';
        }
        return 'Đã kết thúc';

      case DiscountStatus.all:
        return '';
      case DiscountStatus.canceled:
        return '';
    }
  }

  Color get toColor => switch (this) {
        DiscountStatus.scheduled => MyColors.warningColor,
        DiscountStatus.running => MyColors.successColor,
        DiscountStatus.finished => MyColors.closeColor,
        DiscountStatus.all => MyColors.successColor,
        DiscountStatus.canceled => MyColors.errorColor
      };
}
