class GetVoucherOrderRequest {
  final String shopId;
  final List<String> productIds;
  final num totalOrderAmount;
  final String userId;
  final String? code;

  GetVoucherOrderRequest(
      {required this.shopId,
      required this.productIds,
      required this.totalOrderAmount,
      required this.userId,
      this.code});

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      "productIds": productIds,
      "totalOrderAmount": totalOrderAmount,
      "userId": userId,
      if (code != null) 'code': code,
    };
  }
}
