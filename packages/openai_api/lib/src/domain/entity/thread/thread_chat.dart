class ThreadChat {
  final String? id;
  final String? object;
  final int? createdAt;
  final String? assistantId;
  final String? threadId;
  final String? runId;
  final String? role;
  final String? content;

  ThreadChat({
    this.id,
    this.object,
    this.createdAt,
    this.assistantId,
    this.threadId,
    this.runId,
    this.role,
    this.content,
  });

  ThreadChat copyWith({
    String? id,
    String? object,
    int? createdAt,
    String? assistantId,
    String? threadId,
    String? runId,
    String? role,
    String? content,
  }) {
    return ThreadChat(
      id: id ?? this.id,
      object: object ?? this.object,
      createdAt: createdAt ?? this.createdAt,
      assistantId: assistantId ?? this.assistantId,
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }
}
