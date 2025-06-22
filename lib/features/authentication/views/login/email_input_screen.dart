import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/otp_controller.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/login_screen.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/login_header.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/OTP_verification_screen.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:food_delivery_h2d/utils/validations/validators.dart';
import 'package:get/get.dart';

class EmailInputScreen extends StatelessWidget {
  EmailInputScreen({super.key, this.isResetPassword = false});

  final bool isResetPassword;

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);

  final otpController = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: MySizes.iconMd,
                ),
              ),

              const SizedBox(
                height: MySizes.spaceBtwItems,
              ),
              Text("Xác thực tài khoản",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .apply(color: Colors.white)),
            ],
          )),
          Padding(
              padding: const EdgeInsets.all(MySizes.defaultSpace),
              child: Form(
                  key: emailFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) => Validators.validateEmail(value),
                        controller: emailController,
                        decoration: const InputDecoration(
                            hintText: "Nhập email đã đăng ký!"),
                      ),
                      const SizedBox(
                        height: MySizes.defaultSpace,
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        children: UserRole.values.map((role) {
                          return Obx(() => RadioListTile<UserRole>(
                                title:
                                    Text(ConvertEnumRole.toDisplayName(role)),
                                value: role,
                                groupValue: selectedRole.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    selectedRole.value = value;
                                  }
                                },
                              ));
                        }).toList(),
                      ),
                      const SizedBox(
                        height: MySizes.defaultSpace,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!emailFormKey.currentState!.validate()) {
                                return;
                              }
                              if (selectedRole.value == null) {
                                Loaders.errorSnackBar(
                                    title: "Lỗi!",
                                    message: "Vui lòng chọn vai trò!");
                                return;
                              }

                              if (isResetPassword) {
                                final success =
                                    await otpController.resetPassword(
                                        emailController.text,
                                        selectedRole.value!.name);
                                if (success) {
                                  Get.offAll(() => const LoginScreen());
                                }
                              } else {
                                final success = await otpController.resendOTP(
                                    emailController.text,
                                    selectedRole.value!.name);
                                if (success) {
                                  Get.to(() => OtpVerificationScreen(
                                      emailAddress: emailController.text,
                                      role: selectedRole.value!.name));
                                }
                              }
                            },
                            child: const Text("Tiếp")),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}
