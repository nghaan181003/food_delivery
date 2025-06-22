import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/my_text_filed.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/customers/profile/controllers/update_profile_customer_controller.dart';
import 'package:food_delivery_h2d/features/customers/profile/views/widgets/profile_customer_header.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/controllers/update_profile_restaurant_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/views/widgets/profile_header.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ProfileCustomerDetailScreen extends StatelessWidget {
  ProfileCustomerDetailScreen({super.key});
  final controller =
      Get.put(UpdateProfileCustomerController());
      void loadCustomerInfor() {
        final currentUser = LoginController.instance.currentUser;
        controller.nameController.text = currentUser.name;
        controller.phoneNumberController.text = currentUser.phone;
        controller.emailController.text = currentUser.email;
      }

  @override
  Widget build(BuildContext context) {
    loadCustomerInfor();
    return Scaffold(
        appBar: CustomAppBar(
          title: const Text("Chỉnh sửa thông tin"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.done,
                size: MySizes.iconMd,
              ),
              onPressed: () {
                controller.updateUser(LoginController.instance.currentUser.userId);
              },
            ),
          ],
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
                          child: MyTextFiled(
                            textController: controller
                                .nameController,
                            hintText: "Họ và tên",
                          ),
                        )
                      ],
                    ),
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
                          child: MyTextFiled(
                            textController: controller
                                .phoneNumberController,
                            hintText: "Số điện thoại",
                          ),
                        )
                      ],
                    ),
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
                          width: 200,
                          child: MyTextFiled(
                            textController: controller
                                .emailController,
                            hintText: "Email",
                            readOnly: true,
                          ),
                        )
                      ],
                    ),
                  
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
