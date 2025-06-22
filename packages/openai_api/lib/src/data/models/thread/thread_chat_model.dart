
import 'package:openai_api/src/domain/entity/thread/thread_chat.dart';

class ThreadChatModel {
  final String? id;
  final String? object;
  final int? createdAt;
  final String? assistantId;
  final String? threadId;
  final String? runId;
  final String? role;
  final String? content;
  final List<dynamic>? attachments;
  final Map<String, dynamic>? metadata;

  ThreadChatModel({
    this.id,
    this.object,
    this.createdAt,
    this.assistantId,
    this.threadId,
    this.runId,
    this.role,
    this.content,
    this.attachments,
    this.metadata,
  });

  ThreadChatModel copyWith({
    String? id,
    String? object,
    int? createdAt,
    String? assistantId,
    String? threadId,
    String? runId,
    String? role,
    String? content,
    List<dynamic>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return ThreadChatModel(
      id: id ?? this.id,
      object: object ?? this.object,
      createdAt: createdAt ?? this.createdAt,
      assistantId: assistantId ?? this.assistantId,
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      role: role ?? this.role,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }

  factory ThreadChatModel.fromMap(Map<String, dynamic> map) {
    final listContent = map['content'] as List;
    return ThreadChatModel(
      id: map['id'],
      object: map['object'],
      createdAt: map['created_at'],
      assistantId: map['assistant_id'],
      threadId: map['thread_id'],
      runId: map['run_id'],
      role: map['role'],
      content: (listContent.isNotEmpty)
          ? (listContent.first['text']?['value'] ?? '')
          : '',
      attachments: List<dynamic>.from(map['attachments']),
      metadata: {},
    );
  }

  ThreadChat toEntity() {
    return ThreadChat(
      id: id,
      object: object,
      createdAt: createdAt,
      assistantId: assistantId,
      threadId: threadId,
      runId: runId,
      role: role,
      content: content,
    );
  }

}
