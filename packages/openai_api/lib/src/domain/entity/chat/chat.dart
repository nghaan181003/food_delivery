import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_api/src/domain/entity/chat/chat_status.dart';
import 'package:openai_api/src/domain/entity/chat/chat_type.dart';

part 'chat.freezed.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String conversationId,
    required String title,
    required DateTime createdAt,
    DateTime? updatedAt,
    required ChatStatus chatStatus,
    required ChatType chatType,
  }) = _Chat;
}
