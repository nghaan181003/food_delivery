import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';

class PartnerModel extends UserModel {
  final String partnerId;
  final String avatarUrl;
  final String storeFront;
  final String cccdFrontUrl;
  final String cccdBackUrl;
  final String description;
  final bool partnerStatus;
  final List<String> categoryOrderIdx;
  final String provinceId;
  final String districtId;
  final String communeId;
  final String detailAddress;

  PartnerModel({
    required this.partnerId,
    required this.avatarUrl,
    required this.storeFront,
    required this.cccdFrontUrl,
    required this.cccdBackUrl,
    required this.description,
    required this.partnerStatus,
    required this.categoryOrderIdx,
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

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'] ?? {};
    var userData = data['userId'] ?? {};

    return PartnerModel(
      partnerId: data['_id'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      storeFront: data['storeFront'] ?? '',
      cccdFrontUrl: data['CCCDFrontUrl'] ?? '',
      cccdBackUrl: data['CCCDBackUrl'] ?? '',
      description: data['description'] ?? '',
      partnerStatus: data['status'] ?? false,
      categoryOrderIdx: List<String>.from(data['categoryOrderIdx'] ?? []),
      provinceId: data['provinceId'] ?? '',
      districtId: data['districtId'] ?? '',
      communeId: data['communeId'] ?? '',
      detailAddress: data['detailAddress'] ?? '',
      userId: userData['_id'] ?? '',
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      password: userData['password'] ?? '',
      status: userData['status'] ?? false,
      role: userData['role'] ?? '',
      phone: userData['phone'] ?? '',
      createdAt: DateTime.parse(userData['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(userData['updatedAt'] ?? DateTime.now().toString()),
      isDeleted: userData['isDeleted'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'partnerId': partnerId,
      'avatarUrl': avatarUrl,
      'storeFront': storeFront,
      'CCCDFrontUrl': cccdFrontUrl,
      'CCCDBackUrl': cccdBackUrl,
      'description': description,
      'status': partnerStatus,
      'categoryOrderIdx': categoryOrderIdx,
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
