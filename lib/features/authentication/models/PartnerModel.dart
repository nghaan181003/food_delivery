import 'package:food_delivery_h2d/features/authentication/models/User.dart';

class PartnerModel extends UserModel {
  PartnerModel(
      {required this.partnerId,
      required this.description,
      required this.provinceId,
      required this.districtId,
      required this.communeId,
      required this.detailAddress,
      required this.fullAddress,
      required this.latitude,
      required this.longitude,
      required this.avatarUrl,
      required this.storeFront,
      required this.CCCDFrontUrl,
      required this.CCCDBackUrl,
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

  final String partnerId;
  final String description;
  final String provinceId;
  final String districtId;
  final String communeId;
  final String detailAddress;
  final String fullAddress;
  final double? latitude;
  final double? longitude;
  final String avatarUrl;
  final String storeFront;
  final String CCCDFrontUrl;
  final String CCCDBackUrl;
  bool workingStatus;

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    final user = json["userId"] is Map<String, dynamic>
        ? UserModel.fromJson(json["userId"])
        : UserModel.fromJson(json);
    return PartnerModel(
      partnerId: json["_id"],
      description: json["description"],
      provinceId: json["provinceId"],
      districtId: json['districtId'] ?? '',
      communeId: json['communeId'] ?? '',
      detailAddress: json['detailAddress'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      avatarUrl: json["avatarUrl"] ?? '',
      storeFront: json["storeFront"] ?? '',
      CCCDFrontUrl: json["CCCDFrontUrl"] ?? '',
      CCCDBackUrl: json["CCCDBackUrl"] ?? '',
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
      '_id': partnerId,
      'provinceId': provinceId,
      'districtId': districtId,
      'description': description,
      'communeId': communeId,
      'detailAddress': detailAddress,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'avatarUrl': avatarUrl,
      'storeFront': storeFront,
      'CCCDFrontUrl': CCCDFrontUrl,
      'CCCDBackUrl': CCCDBackUrl
    };
  }
}
