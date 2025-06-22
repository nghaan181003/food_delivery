import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/wallet/controllers/wallet_controller.dart';
import 'package:food_delivery_h2d/features/wallet/views/transaction_payment_tile.dart';
import 'package:food_delivery_h2d/features/wallet/views/transaction_refund_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());

    return Scaffold(
        appBar: const CustomAppBar(
          title: Text("Ví của tôi"),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Số dư ví: ",
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            )),
                            Text(MyFormatter.formatCurrency(controller.balance.value),
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              color: MyColors.primaryColor,
                              height: 2,
                            )),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: MySizes.md, right: MySizes.md),
                child: Divider(color: MyColors.dividerColor),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Lịch sử giao dịch",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Obx(() {
                if (controller.transactions.isEmpty) {
                  return const Center(
                      child: Text("Chưa có giao dịch nào được thực hiện"));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = controller.transactions[index];
                      if (transaction.type == "refund") {
                        return TransactionRefundTile(transaction: transaction);
                      } else if (transaction.type == "payment" &&
                          transaction.payer !=
                              LoginController.instance.currentUser.userId) {
                        return TransactionPaymentTile(
                          transaction: transaction,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                );
              })
            ],
          );
        }));
  }
}
