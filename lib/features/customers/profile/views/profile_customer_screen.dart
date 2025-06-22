import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/changePassword.dart';
import 'package:food_delivery_h2d/features/customers/profile/controllers/update_profile_customer_controller.dart';
import 'package:food_delivery_h2d/features/customers/profile/views/profile_customer_detail_screen.dart';
import 'package:food_delivery_h2d/features/customers/profile/views/widgets/profile_customer_header.dart';
import 'package:food_delivery_h2d/features/wallet/views/wallet_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class ProfileCustomerScreen extends StatelessWidget {
  const ProfileCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileCustomerController>(
      init: UpdateProfileCustomerController(),
      builder: (controller) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: Text("Hồ sơ của tôi"),
            showBackArrow: false,
            actions: [ChangingPassword()],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ProfileCustomerHeader(),
                const SizedBox(
                  height: MySizes.spaceBtwSections,
                ),
                Padding(
                  padding: const EdgeInsets.all(MySizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Họ tên",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              LoginController.instance.currentUser.name,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: MyColors.primaryTextColor,
                                        height: 2,
                                      ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Số điện thoại",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              LoginController.instance.currentUser.phone,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: MyColors.primaryTextColor,
                                        height: 2,
                                      ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 220,
                            child: Text(
                              LoginController.instance.currentUser.email,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: MyColors.primaryTextColor,
                                        height: 2,
                                      ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ngày tạo tài khoản",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              MyFormatter.formatDateTime(
                                  LoginController.instance.currentUser.createdAt),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: MyColors.primaryTextColor,
                                        height: 2,
                                      ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      InkWell(
                        onTap: () => Get.to(const WalletScreen()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ví của tôi",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .apply(color: MyColors.darkPrimaryTextColor),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: MySizes.iconSm, color: MyColors.secondaryTextColor,)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: MySizes.spaceBtwSections,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Get.to(() => ProfileCustomerDetailScreen());
                            controller.update();
                          },
                          child: const Text("Chỉnh sửa thông tin"),
                        ),
                      ),
                      const SizedBox(
                        height: MySizes.spaceBtwItems,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            LoginController.instance.logout();
                          },
                          child: const Text("Đăng xuất"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
