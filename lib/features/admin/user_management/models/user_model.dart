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
  final bool isDeleted;
  UserModel(
      {required this.userId,
      required this.name,
      required this.email,
      required this.password,
      required this.status,
      required this.role,
      required this.phone,
      required this.createdAt,
      required this.updatedAt,
      required this.isDeleted});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'] ?? '', // Gán chuỗi rỗng nếu là null
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      status: json['status'] ?? false, // Giả sử status luôn có giá trị boolean
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ??
          DateTime.now().toString()), // Nếu null, dùng thời gian hiện tại
      updatedAt: DateTime.parse(json['updatedAt'] ??
          DateTime.now().toString()), // Nếu null, dùng thời gian hiện tại
      isDeleted: json['isDeleted'] ?? false,
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
      'isDeleted': isDeleted
    };
  }

  void printInfo() {
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
}
