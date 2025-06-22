class UserModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final bool status;
  final String role;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel(
      {required this.userId,
      required this.name,
      required this.email,
      required this.password,
      required this.status,
      required this.role,
      required this.phone,
      required this.createdAt,
      required this.updatedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      status:
          json['status'] is bool ? json['status'] : json['status'] == 'true',
      role: json['role'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert a User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'name': name,
      'email': email,
      'password': password,
      'status': status.toString(),
      'role': role,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  void getInfo() {
    print("User Info:");
    print("ID: $userId");
    print("Name: $name");
    print("Email: $email");
    print("Status: $status");
    print("Role: $role");
    print("Phone: $phone");
    print("Created At: $createdAt");
    print("Updated At: $updatedAt");
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? password,
    bool? status,
    String? role,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
