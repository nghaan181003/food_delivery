import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';

part 'conversation_modal_state.freezed.dart';

@freezed
class ConversationModalState with _$ConversationModalState {
  const factory ConversationModalState({
    required List<Conversation> conversations,
    @Default([]) List<Conversation> selectedConversations,
  }) = _ConversationViewState;
}
