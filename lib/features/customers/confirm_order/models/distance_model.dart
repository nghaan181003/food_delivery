class Distance {
  double? distance;
  String? distanceUnit;
  double? duration;
  String? durationUnit;
  String? formattedDuration;

  Distance({
    this.distance,
    this.distanceUnit,
    this.duration,
    this.durationUnit,
    this.formattedDuration,
  });

  Map<String, dynamic> toJson() => {
        'distance': distance,
        'distanceUnit': distanceUnit,
        'duration': duration,
        'durationUnit': durationUnit,
        'formattedDuration': formattedDuration,
      };

  factory Distance.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid distance format: JSON is null');
    }

    try {
      return Distance(
        distance: _parseToDouble(json['distance']),
        distanceUnit: json['distanceUnit'] as String? ?? 'km',
        duration: _parseToDouble(json['duration']),
        durationUnit: json['durationUnit'] as String? ?? 'seconds',
        formattedDuration: json['formattedDuration'] as String? ?? '0 phút',
      );
    } catch (e) {
      throw Exception('Invalid distance format received from API: $e');
    }
  }

  static double? _parseToDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed == null) throw Exception('Cannot parse string to double: $value');
      return parsed;
    }
    throw Exception('Unsupported type for distance/duration: ${value.runtimeType}');
  }
}