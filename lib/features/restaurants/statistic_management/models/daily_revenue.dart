class DailyRevenueModel {
  final DateTime date;
  final double revenue;

  DailyRevenueModel({required this.date, required this.revenue});

  factory DailyRevenueModel.fromJson(Map<String, dynamic> json) {
    return DailyRevenueModel(
      date: DateTime.parse(json['date']),
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}
