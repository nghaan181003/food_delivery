class RatingModel {
  final String orderId;
  final double custResRating;
  final String custResRatingComment;
  final String customerName;
  final String custShipperRatingComment;
  final DateTime orderDatetime;
  final double custShipperRating;
  final String customerId;

  RatingModel(
      {required this.orderId,
      required this.customerId,
      required this.custResRating,
      required this.custResRatingComment,
      required this.customerName,
      required this.custShipperRatingComment,
      required this.orderDatetime,
      required this.custShipperRating});

  // Factory constructor để tạo RatingModel từ dữ liệu JSON
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      customerId: json['custId'] ?? "",
      orderId: json['orderId'],
      custResRating: json['custResRating']?.toDouble() ?? 0.0,
      custResRatingComment: json['custResRatingComment'] ?? '',
      customerName: json['customerName'] ?? 'Unknown',
      custShipperRatingComment: json['custShipperRatingComment'] ?? '',
      orderDatetime: DateTime.parse(json['orderDatetime']),
      custShipperRating: json['custShipperRating']?.toDouble() ?? 0.0,
    );
  }

  // Phương thức toJson để chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'custResRating': custResRating,
      'custResRatingComment': custResRatingComment,
      'customerName': customerName,
      'custShipperRatingComment': custShipperRatingComment,
      'orderDatetime': orderDatetime.toIso8601String(),
      'custShipperRating': custShipperRating,
    };
  }
}
