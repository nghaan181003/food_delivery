class DistrictModel {
  final String id;
  final String name;
  final String nameEn;
  final String fullName;
  final String fullNameEn;
  final String latitude;
  final String longitude;

  DistrictModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.fullName,
    required this.fullNameEn,
    required this.latitude,
    required this.longitude,
  });

  // Factory constructor to create a ProvinceModel from JSON
  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      fullName: json['full_name'] as String,
      fullNameEn: json['full_name_en'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }
}
