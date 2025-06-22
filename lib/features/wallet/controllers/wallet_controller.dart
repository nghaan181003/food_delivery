import 'package:food_delivery_h2d/data/wallet/wallet_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/wallet/models/transaction_model.dart';
import 'package:food_delivery_h2d/features/wallet/models/wallet_model.dart';
import 'package:get/get.dart';


class WalletController extends GetxController {
  static WalletController get instance => Get.find();
  final walletRepository = Get.put(WalletRepository());

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var wallet = Rxn<WalletModel>();
  var transactions = <TransactionModel>[].obs;
  var balance = 0.obs;
@override
  void onInit() async {
    fetchWallet();
    super.onInit();
  }
  Future<void> fetchWallet() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await walletRepository.fetchWallet(LoginController.instance.currentUser.userId);
      balance.value = data.balance;
      transactions.assignAll(data.transactions);
    } catch (e) {
      errorMessage.value = 'Lỗi tải ví: $e';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
