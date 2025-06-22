import 'package:food_delivery_h2d/features/authentication/models/User.dart';

class DriverModel extends UserModel {
  DriverModel(
      {required this.driverId,
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
      this.workingStatus = false,
      required super.role,
      required super.phone,
      required super.createdAt,
      required super.updatedAt});

  final String driverId;
  final String licensePlate;
  final String profileUrl;
  final String licenseFrontUrl;
  final String licenseBackUrl;
  final String provinceId;
  final String districtId;
  final String communeId;
  final String detailAddress;
  bool workingStatus;

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    // final user = UserModel.fromJson(json["userId"]);
    final user = json["userId"] is Map<String, dynamic>
        ? UserModel.fromJson(json["userId"])
        : UserModel.fromJson(json);
    return DriverModel(
      driverId: json["_id"],
      licensePlate: json['licensePlate'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      licenseFrontUrl: json['licenseFrontUrl'] ?? '',
      licenseBackUrl: json['licenseBackUrl'] ?? '',
      provinceId: json['provinceId'] ?? '',
      districtId: json['districtId'] ?? '',
      communeId: json['communeId'] ?? '',
      detailAddress: json['detailAddress'] ?? '',
      workingStatus: json['status'] ?? '',
      userId: user.userId,
      name: user.name,
      email: user.email,
      password: user.password,
      status: user.status,
      role: user.role,
      phone: user.phone,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final userJson = super.toJson();

    return {
      ...userJson,
      '_id': driverId,
      'licensePlate': licensePlate,
      'profileUrl': profileUrl,
      'licenseFrontUrl': licenseFrontUrl,
      'licenseBackUrl': licenseBackUrl,
      'provinceId': provinceId,
      'districtId': districtId,
      'communeId': communeId,
      'detailAddress': detailAddress,
    };
  }
}
