class UpdateRequest {
  final String id;
  final String partnerId;
  final String name;
  final String email;
  final String userId;
  final String phone;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> updatedFields;

  UpdateRequest({
    required this.id,
    required this.partnerId,
    required this.name,
    required this.email,
    required this.phone,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedFields,
  });

  factory UpdateRequest.fromJson(Map<String, dynamic> json) {
    return UpdateRequest(
      id: json['_id'] ?? '',
      partnerId: json['partnerId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      updatedFields: Map<String, dynamic>.from(json['updatedFields'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'partnerId': partnerId,
      'name': name,
      'email': email,
      'phone': phone,
      'userId': userId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'updatedFields': updatedFields,
    };
  }
}
