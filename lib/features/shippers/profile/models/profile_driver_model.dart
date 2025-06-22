class ProfileDriverModel {
  int driverId;
  DateTime joinDate;
  String name;
  String phone;
  String email;
  String licensePlate;
  String profileUrl;
  String licenseFrontUrl;
  String licenseBackUrl;

  ProfileDriverModel({
    this.driverId = 0,
    DateTime? joinDate,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.licensePlate = '',
    this.profileUrl = '',
    this.licenseFrontUrl = '',
    this.licenseBackUrl = '',
  })  : joinDate = joinDate ?? DateTime.now();

  factory ProfileDriverModel.fromJson(Map<String, dynamic> json) {
    return ProfileDriverModel(
      driverId: json['driverId'] ?? 0,
      joinDate: DateTime.tryParse(json['joinDate'] ?? '') ?? DateTime.now(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      licenseFrontUrl: json['licenseFrontUrl'] ?? '',
      licenseBackUrl: json['licenseBackUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'joinDate': joinDate.toIso8601String(),
      'name': name,
      'phone': phone,
      'email': email,
      'licensePlate': licensePlate,
      'profileUrl': profileUrl,
      'licenseFrontUrl': licenseFrontUrl,
      'licenseBackUrl': licenseBackUrl,
    };
  }
}
