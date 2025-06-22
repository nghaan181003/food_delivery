import 'package:get/get.dart';

class NotificationModel {
  final String id;
  final String recipientId;
  final String title;
  final String content;
  final RxBool isRead;
  final DateTime sentAt;

  // Constructor chính xác
  NotificationModel({
    required this.id,
    required this.recipientId,
    required this.title,
    required this.content,
    required bool isReadRaw,
    required this.sentAt,
  }) : isRead = isReadRaw.obs;

  // Phương thức factory để chuyển đổi từ JSON sang NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      recipientId: json['recipientId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isReadRaw: json['isRead'] ?? false, // truyền bool
      sentAt: json['sentAt'] != null
          ? DateTime.tryParse(json['sentAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Phương thức để chuyển từ NotificationModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipientId': recipientId,
      'title': title,
      'content': content,
      'isRead': isRead.value, // Lấy giá trị bool từ Rx
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
