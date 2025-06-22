part of 'conversation_bloc.dart';

@freezed
class ConversationEvent with _$ConversationEvent {
  const factory ConversationEvent.stated() = _Started;

  const factory ConversationEvent.getConversation() = _GetConversation;

  const factory ConversationEvent.createConversation() = _CreateConversation;

  const factory ConversationEvent.deleteConversation(
      {required int conversationId}) = _DeleteConversation;

  const factory ConversationEvent.selectConversation(
      {required int conversationId}) = _SelectConversation;

  const factory ConversationEvent.updateConversation({
    required int conversationId,
    required String lastMessage,
    String? title,
  }) = _UpdateConversation;

  const factory ConversationEvent.updateSelectedConversation(
      {required Conversation conversation}) = _UpdateSelectedConversation;
}
