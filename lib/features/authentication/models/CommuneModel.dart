class CommuneModel {
  final String id;
  final String name;
  final String nameEn;
  final String fullName;
  final String fullNameEn;
  final String latitude;
  final String longitude;

  CommuneModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.fullName,
    required this.fullNameEn,
    required this.latitude,
    required this.longitude,
  });

  // Factory constructor to create a CommuneModel from a JSON map
  factory CommuneModel.fromJson(Map<String, dynamic> json) {
    return CommuneModel(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      fullName: json['full_name'],
      fullNameEn: json['full_name_en'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Method to convert a CommuneModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'full_name': fullName,
      'full_name_en': fullNameEn,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
