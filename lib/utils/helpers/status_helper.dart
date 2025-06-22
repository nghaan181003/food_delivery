import 'package:flutter/material.dart';

class StatusHelper {
  static const Map<String, Color> custStatusColors = {
    "waiting": Colors.grey,
    "heading_to_rest": Colors.orange,
    "preparing": Colors.blue,
    "delivering": Color.fromARGB(255, 14, 178, 175),
    "delivered": Colors.green,
    "cancelled": Colors.red,
  };

  static const Map<String, Color> driverStatusColors = {
    "waiting": Colors.grey,
    "heading_to_rest": Colors.orange,
    "delivering": Color.fromARGB(255, 14, 178, 175),
    "delivered": Colors.green,
    "cancelled": Colors.red,
    "approved": Colors.blue,
    "reported": Colors.redAccent,
  };

  static const Map<String, Color> restStatusColors = {
    "new": Colors.blueGrey,
    "preparing": Colors.blue,
    "completed": Colors.green,
    "cancelled": Colors.red,
  };

  static const Map<String, String> custStatusTranslations = {
    "waiting": "Đang chờ",
    "heading_to_rest": "Đang đến quán",
    "preparing": "Đang chuẩn bị",
    "delivering": "Đang giao",
    "delivered": "Đã giao",
    "cancelled": "Đã hủy",
  };

  static const Map<String, String> driverStatusTranslations = {
    "waiting": "Đang chờ",
    "heading_to_rest": "Đang đến quán",
    "delivering": "Đang giao",
    "delivered": "Đã giao",
    "cancelled": "Đã hủy",
    "reported": "Được báo cáo",
    "approved": "Đã duyệt",
    "rejected": "Không được duyệt"
  };

  static const Map<String, String> restStatusTranslations = {
    "new": "Đơn mới",
    "preparing": "Đang chuẩn bị",
    "completed": "Hoàn thành",
    "cancelled": "Đã hủy",
  };

  // Utility methods
  static Color getColor(String statusType, String status) {
    switch (statusType) {
      case 'custStatus':
        return custStatusColors[status] ?? Colors.grey;
      case 'driverStatus':
        return driverStatusColors[status] ?? Colors.grey;
      case 'restStatus':
        return restStatusColors[status] ?? Colors.grey;
      default:
        return Colors.grey;
    }
  }

  static String getTranslation(String statusType, String status) {
    switch (statusType) {
      case 'custStatus':
        return custStatusTranslations[status] ?? "Không xác định";
      case 'driverStatus':
        return driverStatusTranslations[status] ?? "Không xác định";
      case 'restStatus':
        return restStatusTranslations[status] ?? "Không xác định";
      default:
        return "Không xác định";
    }
  }

  static const Map<String, String> orderStatusTranslations = {
    "": "Tất cả",
    "new": "Đơn mới",
    "waiting": "Đang chờ",
    "heading_to_rest": "Đang đến quán",
    "preparing": "Đang chuẩn bị",
    "delivering": "Đang giao",
    "completed": "Hoàn thành",
    "delivered": "Đã giao",
    "cancelled": "Đã hủy",
    "reported": "Được báo cáo",
    "approved": "Đã được duyệt",
    "rejected": "Không được duyệt"

  };

  static const Map<String, String> updateRequestStatus = {
    "pending": "Đang chờ duyệt",
    "approved": "Đã duyệt",
    "rejected": "Từ chối"
  };
  static const Map<String, Color> updateRequestStatusColors = {
    "approved": Colors.orange,
    "pending": Colors.green,
    "rejected": Colors.red,
  };
}
