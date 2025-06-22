import 'package:food_delivery_h2d/features/wallet/models/wallet_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class WalletRepository extends GetxController{
  static WalletRepository get instance => Get.find();

  Future<WalletModel> fetchWallet(String userId) async {
  try {
    final jsonData = await HttpHelper.get("wallet/$userId");
    return WalletModel.fromJson(jsonData);
  } catch (e) {
    throw Exception('Failed to load wallet: $e');
  }
}

}
