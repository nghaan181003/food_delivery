import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/email_input_screen.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/register_navigation_menu.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:food_delivery_h2d/utils/validations/validators.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/login_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(LoginController());
    return Form(
        key: authController.loginFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: authController.userNameController,
              validator: (value) => Validators.validateEmail(value),
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Tên đăng nhập",
                prefixIcon: Icon(Icons.person, size: MySizes.iconMs),
              ),
            ),
            const SizedBox(
              height: MySizes.spaceBtwInputFields,
            ),
            Obx(
              () => TextFormField(
                controller: authController.passwordController,
                obscureText: !authController.isShowPassword.value,
                validator: (value) =>
                    Validators.validateEmptyText("Mật khẩu", value),
                decoration: InputDecoration(
                  hintText: "Mật khẩu",
                  prefixIcon: const Icon(Icons.lock, size: MySizes.iconMs),
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.isShowPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: MySizes.iconMs,
                    ),
                    onPressed: () => authController.togglePasswordVisibility(),
                  ),
                ),
              ),
            ),
            if (!kIsWeb)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.to(() => EmailInputScreen());
                      },
                      child: const Text("Xác thực tài khoản")),
                  TextButton(
                      onPressed: () {
                        Get.to(() => EmailInputScreen(
                              isResetPassword: true,
                            ));
                      },
                      child: const Text("Quên mật khẩu")),
                ],
              ),
            if (kIsWeb)
              const SizedBox(
                height: MySizes.spaceBtwItems,
              ),
            if (!kIsWeb)
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                children: UserRole.values.map((role) {
                  return Obx(() => RadioListTile<UserRole>(
                        title: Text(ConvertEnumRole.toDisplayName(role)),
                        value: role,
                        groupValue: authController.selectedRole.value,
                        onChanged: (value) {
                          if (value != null) {
                            authController.selectedRole.value = value;
                          }
                        },
                      ));
                }).toList(),
              ),
            const SizedBox(
              height: MySizes.spaceBtwItems,
            ),
            Obx(
              () => authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authController.login,
                        child: const Text("Đăng nhập"),
                      ),
                    ),
            ),
            const SizedBox(
              height: MySizes.spaceBtwItems,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => const RegisterNavigationMenu());
                },
                child: const Text("Đăng ký"),
              ),
            )
          ],
        ));
  }
}
