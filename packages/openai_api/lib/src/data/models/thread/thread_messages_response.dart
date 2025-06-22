import 'package:openai_api/src/data/models/thread/thread_chat_model.dart';

class ThreadMessagesResponse {
  final String? object;
  final List<ThreadChatModel>? data;
  final String? firstId;
  final String? lastId;
  final bool? hasMore;

  ThreadMessagesResponse({
    this.object,
    this.data,
    this.firstId,
    this.lastId,
    this.hasMore,
  });

  ThreadMessagesResponse copyWith({
    String? object,
    List<ThreadChatModel>? data,
    String? firstId,
    String? lastId,
    bool? hasMore,
  }) {
    return ThreadMessagesResponse(
      object: object ?? this.object,
      data: data ?? this.data,
      firstId: firstId ?? this.firstId,
      lastId: lastId ?? this.lastId,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory ThreadMessagesResponse.fromJson(Map<String, dynamic> map) {
    return ThreadMessagesResponse(
      object: map['object'],
      data: List<ThreadChatModel>.from(
          map['data']?.map((x) => ThreadChatModel.fromMap(x))),
      firstId: map['first_id'],
      lastId: map['last_id'],
      hasMore: map['has_more'],
    );
  }
}
