import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    required DateTime createdAt,
    @Default("JoJo") String header,
    @Default("...") String title,
    String? lastMessage,
    String? threadId,
    DateTime? lastUpdate,
  }) = _Conversation;
}
