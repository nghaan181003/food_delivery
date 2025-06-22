class Config {
  String? id;
  String type;
  Map<String, dynamic> data;
  String? description;

  Config({
    this.id,
    required this.type,
    required this.data,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'data': data,
        'description': description,
      };

  factory Config.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Config(
        type: 'DELIVERY_FEE',
        data: {},
      );
    }
    return Config(
      id: json['_id'] as String?,
      type: json['type'] as String? ?? 'DELIVERY_FEE',
      data: (json['data'] is Map<String, dynamic>) ? json['data'] : {},
      description: json['description'] as String?,
    );
  }
}
