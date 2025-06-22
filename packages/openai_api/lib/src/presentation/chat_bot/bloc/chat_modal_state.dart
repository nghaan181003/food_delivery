import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_api/src/domain/entity/chat/chat.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';

part 'chat_modal_state.freezed.dart';

@freezed
class ChatModalState with _$ChatModalState {
  const factory ChatModalState({
    required List<Chat> chats,
    Conversation? conversation,
    String? messageId,
    @Default(false) bool micAvailable,
    @Default(false) bool textAnimation,
  }) = _ChatModalState;
}
