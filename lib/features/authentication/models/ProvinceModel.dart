class ProvinceModel {
  final String id;
  final String name;
  final String nameEn;
  final String fullName;
  final String fullNameEn;
  final double latitude;
  final double longitude;

  ProvinceModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.fullName,
    required this.fullNameEn,
    required this.latitude,
    required this.longitude,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      fullName: json['full_name'] as String,
      fullNameEn: json['full_name_en'] as String,
      latitude: double.parse(json['latitude'] as String),
      longitude: double.parse(json['longitude'] as String),
    );
  }
}
