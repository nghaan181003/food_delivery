import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/wallet/models/transaction_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class TransactionRefundTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionRefundTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: MySizes.md,
        right: MySizes.sm,
        left: MySizes.sm,
      ),
      child: Container(
        padding: const EdgeInsets.only(
            left: MySizes.md, top: MySizes.md, bottom: MySizes.md),
        decoration: BoxDecoration(
          color: MyColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.arrow_downward,
                  color: MyColors.openColor,
                ),
                const SizedBox(
                  width: MySizes.md,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 275,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hoàn tiền",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2,
                                    ),
                          ),
                          Text(
                              "${MyFormatter.formatTime(transaction.createdAt.toString())} ${MyFormatter.formatDateTime(transaction.createdAt)}")
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Số tiền: ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: MyColors.primaryTextColor, height: 2),
                        ),
                        Text(
                          "+${MyFormatter.formatCurrency(transaction.amount)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: MyColors.primaryColor, height: 2),
                        ),
                      ],
                    ),
                    Text(
                      "Nội dung:",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: MyColors.primaryTextColor, height: 2),
                    ),
                    SizedBox(
                      width: 280,
                      child: Text.rich(
                        TextSpan(
                          text: "Quý khách được hoàn tiền vì lý do đơn hàng ",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "#${transaction.orderId}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: MyColors.primaryTextColor,
                                      height: 2),
                            ),
                            const TextSpan(
                              text: " bị hủy.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
