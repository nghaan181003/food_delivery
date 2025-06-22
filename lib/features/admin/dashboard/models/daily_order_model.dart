class DailyOrderModel {
  final DateTime date;
  final int total;
  final int delivering;
  final int delivered;
  final int cancelled;

  DailyOrderModel(
      {required this.date,
      required this.total,
      required this.delivering,
      required this.delivered,
      required this.cancelled});

  factory DailyOrderModel.fromJson(Map<String, dynamic> json) {
    return DailyOrderModel(
      date: DateTime.parse(json['date']),
      total: json['total'] ?? 0,
      delivering: json['delivering'] ?? 0,
      delivered: json['delivered'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
    );
  }
}
