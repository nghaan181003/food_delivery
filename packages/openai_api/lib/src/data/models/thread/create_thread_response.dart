class CreateThreadResponse {
  final String? id;
  final String? object;
  final int? createdAt;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? toolResources;

  CreateThreadResponse({
    this.id,
    this.object,
    this.createdAt,
    this.metadata,
    this.toolResources,
  });

  CreateThreadResponse copyWith({
    String? id,
    String? object,
    int? createdAt,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? toolResources,
  }) {
    return CreateThreadResponse(
      id: id ?? this.id,
      object: object ?? this.object,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      toolResources: toolResources ?? this.toolResources,
    );
  }

  factory CreateThreadResponse.fromJson(Map<String, dynamic> map) {
    return CreateThreadResponse(
      id: map['id'],
      object: map['object'],
      createdAt: map['created_at'],
      metadata: map['metadata'],
      toolResources: map['tool_resources'],
    );
  }
}
