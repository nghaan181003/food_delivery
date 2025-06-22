class TimeSlot {
  String open;
  String close;

  TimeSlot({required this.open, required this.close});

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        open: json['open'] ?? '',
        close: json['close'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'open': open,
        'close': close,
      };
}

class DaySchedule {
  String day;
  List<TimeSlot> timeSlots;

  DaySchedule({required this.day, required this.timeSlots});

  factory DaySchedule.fromJson(Map<String, dynamic> json) => DaySchedule(
        day: json['day'] ?? '',
        timeSlots: (json['timeSlots'] as List<dynamic>?)
                ?.map((e) => TimeSlot.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'timeSlots': timeSlots.map((e) => e.toJson()).toList(),
      };
}
class User {
  final String id;
  final String name;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
    };
  }
}

class DetailPartnerModel {
  final String id;
  final User userId;
  final String avatarUrl;
  final String storeFront;
  final String cccdFrontUrl;
  final String cccdBackUrl;
  final String description;
  final bool status;
  final String provinceId;
  final String districtId;
  final String communeId;
  final String detailAddress;
  final double latitude;
  final double longitude;
  final List<DaySchedule> schedule;

  DetailPartnerModel({
    required this.id,
    required this.userId,
    required this.avatarUrl,
    required this.storeFront,
    required this.cccdFrontUrl,
    required this.cccdBackUrl,
    required this.description,
    required this.status,
    required this.provinceId,
    required this.districtId,
    required this.communeId,
    required this.detailAddress,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.schedule = const [],
  });

  // Factory method to create a DetailPartnerModel from JSON data
  factory DetailPartnerModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'] ?? {};

    return DetailPartnerModel(
      id: data['_id'] ?? '',
      userId:
          User.fromJson(data['userId'] ?? {}), // Chuyển thành đối tượng User
      avatarUrl: data['avatarUrl'] ?? '',
      storeFront: data['storeFront'] ?? '',
      cccdFrontUrl: data['CCCDFrontUrl'] ?? '',
      cccdBackUrl: data['CCCDBackUrl'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? false,
      provinceId: data['provinceId'] ?? '',
      districtId: data['districtId'] ?? '',
      communeId: data['communeId'] ?? '',
      detailAddress: data['detailAddress'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      schedule: (data['schedule'] as List<dynamic>?)
              ?.map((e) => DaySchedule.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Method to convert DetailPartnerModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(), // Chuyển đối tượng User thành JSON
      'avatarUrl': avatarUrl,
      'storeFront': storeFront,
      'CCCDFrontUrl': cccdFrontUrl,
      'CCCDBackUrl': cccdBackUrl,
      'description': description,
      'status': status,
      'provinceId': provinceId,
      'districtId': districtId,
      'communeId': communeId,
      'detailAddress': detailAddress,
      'latitude': latitude,
      'longitude': longitude,
      'schedule': schedule.map((e) => e.toJson()).toList(),
    };
  }
}
