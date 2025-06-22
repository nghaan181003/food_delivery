class TransactionModel {
  final String id;
  final String? orderId;
  final String type; 
  final int amount;
  final String? payer;
  final String receiver;
  final DateTime createdAt;
  final String? reason;

  TransactionModel({
    required this.id,
    this.orderId,
    required this.type,
    required this.amount,
    this.payer,
    required this.receiver,
    required this.createdAt,
    this.reason
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'],
      orderId: json['orderId'],
      type: json['type'],
      amount: json['amount'],
      payer: json['payer'],
      receiver: json['receiver'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      reason: json['reason']
    );
  }
}
