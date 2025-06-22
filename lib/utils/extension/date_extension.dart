import 'package:intl/intl.dart';

extension DatetTimeExt on DateTime {
  // ignore: non_constant_identifier_names
  String get formatDMY_HM {
    return DateFormat('dd/MM/yy HH:mm').format(this);
  }

  String calculateDuration(DateTime other) {
    final later = isAfter(other) ? this : other;
    final earlier = isAfter(other) ? other : this;

    final duration = later.difference(earlier);

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days ngày');
    if (hours > 0) parts.add('$hours giờ');
    if (minutes > 0) parts.add('$minutes phút');

    return parts.isNotEmpty ? parts.join(' ') : '0 phút';
  }

  String get toVietnamIsoString {
    final vietnamTime = toUtc().add(const Duration(hours: 7));
    return vietnamTime.toIso8601String();
  }

  String get toUtcIsoString => toUtc().toIso8601String();
}
