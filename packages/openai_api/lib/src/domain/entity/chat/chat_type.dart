enum ChatType { user, assistant }

extension ChatTypeExt on ChatType {
  bool get isUser => this == ChatType.user;
  bool get isAssistant => this == ChatType.assistant;
  String get toTypeString =>
      switch (this) { ChatType.user => "user", _ => "assistant" };
}
