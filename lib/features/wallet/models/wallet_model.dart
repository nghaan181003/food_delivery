import 'transaction_model.dart';

class WalletModel {
  final String success;
  final int balance;
  final List<TransactionModel> transactions;

  WalletModel({
    required this.success,
    required this.balance,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      success: json['success'],
      balance: json['balance'],
      transactions: (json['transactions'] as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList(),
    );
  }
}
