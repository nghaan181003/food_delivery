class VoucherCustomer {
  final String customerId;
  final String customerName;

  VoucherCustomer({
    required this.customerId,
    required this.customerName,
  });

  factory VoucherCustomer.fromJson(Map<String, dynamic> json) {
    return VoucherCustomer(
      customerId: json['customerId'],
      customerName: json['customerName'],
    );
  }
}
