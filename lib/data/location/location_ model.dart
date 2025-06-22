class LocationModel {
  final num? lat;
  final num? lng;
  final int? accuracy;

  LocationModel(this.lat, this.lng, this.accuracy);

  Map<String, dynamic> toJson() {
    return {"lat": lat, "lng": lng, "accuracy": accuracy};
  }
}
