import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';

class DriverModel extends UserModel {
  final String driverId;
  final String licensePlate;
  final String profileUrl;
  final String licenseFrontUrl;
  final String licenseBackUrl;
  final String provinceId;
  final String districtId;
  final String communeId;
  final String detailAddress;

  DriverModel({
    required this.driverId,
    required this.licensePlate,
    required this.profileUrl,
    required this.licenseFrontUrl,
    required this.licenseBackUrl,
    required this.provinceId,
    required this.districtId,
    required this.communeId,
    required this.detailAddress,
    required super.userId,
    required super.name,
    required super.email,
    required super.password,
    required super.status,
    required super.role,
    required super.phone,
    required super.createdAt,
    required super.updatedAt,
    required super.isDeleted
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    // Kiểm tra json['data'] để lấy thông tin từ trường data
    var data = json['data'] ?? {};  // Nếu không có 'data', trả về một Map rỗng
    var userData = data['userId'] ?? {};  // Lấy dữ liệu userId trong data

    return DriverModel(
      driverId: data['_id'] as String,
      licensePlate: data['licensePlate'] as String,
      profileUrl: data['profileUrl'] as String,
      licenseFrontUrl: data['licenseFrontUrl'] as String,
      licenseBackUrl: data['licenseBackUrl'] as String,
      provinceId: data['provinceId'] as String,
      districtId: data['districtId'] as String,
      communeId: data['communeId'] as String,
      detailAddress: data['detailAddress'] as String,
      userId: userData['_id'] as String,
      name: userData['name'] as String,
      email: userData['email'] as String,
      password: userData['password'] as String,
      status: userData['status'] as bool,
      role: userData['role'] as String,
      phone: userData['phone'] as String,
      createdAt: DateTime.parse(userData['createdAt'] as String),
      updatedAt: DateTime.parse(userData['updatedAt'] as String),
      isDeleted: userData['isDeleted'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'licensePlate': licensePlate,
      'profileUrl': profileUrl,
      'licenseFrontUrl': licenseFrontUrl,
      'licenseBackUrl': licenseBackUrl,
      'provinceId': provinceId,
      'districtId': districtId,
      'communeId': communeId,
      'detailAddress': detailAddress,
      'userId': {
        '_id': userId,
        'name': name,
        'email': email,
        'password': password,
        'status': status,
        'role': role,
        'phone': phone,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isDeleted': isDeleted
      },
    };
  }
}
