class IncomeModel {
  final String orderId;
  final double custResRating;
  final String custResRatingComment;
  final String customerName;
  final String custShipperRatingComment;
  final DateTime orderDatetime;
  final double custShipperRating;
  final String status;
  final int deliveryFee;

  IncomeModel({
    required this.orderId,
    required this.custResRating,
    required this.custResRatingComment,
    required this.customerName,
    required this.custShipperRatingComment,
    required this.orderDatetime,
    required this.custShipperRating,
    required this.status,
    required this.deliveryFee,
  });

  // Factory constructor để tạo RatingModel từ dữ liệu JSON
  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      orderId: json['orderId'] ?? '',
      custResRating: (json['custResRating'] ?? 0).toDouble(),
      custResRatingComment: json['custResRatingComment'] ?? '',
      customerName: json['customerName'] ?? 'Unknown',
      custShipperRatingComment: json['custShipperRatingComment'] ?? '',
      orderDatetime: DateTime.parse(json['orderDatetime']),
      custShipperRating: (json['custShipperRating'] ?? 0).toDouble(),
      status: json['status'] ?? 'unknown', // Gán mặc định cho status
      deliveryFee: json['deliveryFee'] ?? 0, // Sửa lại: lấy đúng totalPrice từ JSON
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
      'status': status,
      'deliveryFee': deliveryFee,
    };
  }
}
