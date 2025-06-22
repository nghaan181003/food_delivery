import 'package:hive/hive.dart';
import 'package:openai_api/src/core/components/constant/hive_constant.dart';
import 'package:openai_api/src/domain/entity/chat/chat.dart';
import 'package:openai_api/src/domain/entity/chat/chat_status.dart';
import 'package:openai_api/src/domain/entity/chat/chat_type.dart';

part 'chat_model.g.dart';

@HiveType(typeId: HiveConstant.chatHiveId)
class ChatModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int conversationId;

  @HiveField(2)
  String title;

  @HiveField(3)
  int createdAt;

  @HiveField(4)
  int? updatedAt;

  @HiveField(5)
  String status;

  @HiveField(6)
  String type;

  ChatModel({
    required this.id,
    required this.conversationId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.type,
  });
  Chat get toEntity => Chat(
        id: id.toString(),
        conversationId: conversationId.toString(),
        title: title,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        chatStatus:
            ChatStatus.values.firstWhere((element) => element.name == status),
        chatType: ChatType.values.firstWhere((element) => element.name == type),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt ?? 0),
      );

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: int.parse(chat.id),
      conversationId: int.parse(chat.conversationId),
      title: chat.title,
      createdAt: chat.createdAt.millisecondsSinceEpoch,
      updatedAt: chat.updatedAt?.millisecondsSinceEpoch,
      status: chat.chatStatus.toStatusString,
      type: chat.chatType.toTypeString,
    );
  }

  Map<String, dynamic> get toJson =>
      {"role": type.toLowerCase(), "content": title};
}
