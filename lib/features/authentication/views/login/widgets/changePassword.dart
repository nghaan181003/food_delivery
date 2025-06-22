import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/authentication/auth_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:food_delivery_h2d/utils/validations/validators.dart';
import 'package:get/get.dart';

class ChangingPassword extends StatelessWidget {
  const ChangingPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.edit,
          size: MySizes.iconMd,
        ),
        onPressed: () {
          var isShowOldPassword = false.obs;
          var isShowNewPassword = false.obs;
          var isShowConfirmPassword = false.obs;
          final oldPasswordController = TextEditingController();
          final newPasswordController = TextEditingController();
          final confirmPasswordController = TextEditingController();
          GlobalKey<FormState> passWordFormKey = GlobalKey<FormState>();
          void toggleOldPasswordVisibility() {
            isShowOldPassword.value = !isShowOldPassword.value;
          }

          void toggleNewPasswordVisibility() {
            isShowNewPassword.value = !isShowNewPassword.value;
          }

          void toggleConfirmPasswordVisibility() {
            isShowConfirmPassword.value = !isShowConfirmPassword.value;
          }

          // Show dialog for changing password
          Get.defaultDialog(
              contentPadding: const EdgeInsets.all(MySizes.md),
              title: "Thay đổi mật khẩu",
              titlePadding: const EdgeInsets.only(top: 24),
              content: Form(
                  key: passWordFormKey,
                  child: Column(
                    children: [
                      Obx(
                        () => TextFormField(
                          validator: (value) => Validators.validateEmptyText(
                              "Mật khẩu cũ", value),
                          controller: oldPasswordController,
                          obscureText: !isShowOldPassword.value,
                          decoration: InputDecoration(
                            hintText: "Nhập mật khẩu cũ",
                            suffixIcon: IconButton(
                              icon: Icon(
                                isShowOldPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off, size: MySizes.iconMs,
                              ),
                              onPressed: toggleOldPasswordVisibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: MySizes.spaceBtwInputFields,
                      ),
                      Obx(
                        () => TextFormField(
                          validator: (value) => Validators.validateEmptyText(
                              "Mật khẩu mới", value),
                          controller: newPasswordController,
                          obscureText: !isShowNewPassword.value,
                          decoration: InputDecoration(
                              hintText: "Nhập mật khẩu mới",
                              suffixIcon: IconButton(
                              icon: Icon(
                                isShowNewPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off, size: MySizes.iconMs,
                              ),
                              onPressed: toggleNewPasswordVisibility,
                            ),),
                        ),
                      ),
                      const SizedBox(
                        height: MySizes.spaceBtwInputFields,
                      ),
                      Obx(
                        () => TextFormField(
                          validator: (value) => Validators.validateEmptyText(
                              "Xác nhận mật khẩu", value),
                          controller: confirmPasswordController,
                          obscureText: !isShowConfirmPassword.value,
                          decoration: InputDecoration(
                              hintText: "Xác nhận mật khẩu",
                              suffixIcon: IconButton(
                              icon: Icon(
                                isShowConfirmPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off, size: MySizes.iconMs,
                              ),
                              onPressed: toggleConfirmPasswordVisibility,
                            ),),
                        ),
                      )
                    ],
                  )),
              confirm: ElevatedButton(
                  onPressed: () async {
                    try {
                      // handle changing password
                      if (!passWordFormKey.currentState!.validate()) {
                        return;
                      }

                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        Loaders.errorSnackBar(
                            title: "Mật khẩu không trùng khớp!");
                        return;
                      }
                      final res = await AuthRepository.instance.changePassword(
                          LoginController.instance.currentUser.userId,
                          oldPasswordController.text,
                          newPasswordController.text);

                      if (res.status == Status.ERROR) {
                        Loaders.errorSnackBar(
                            title: "Lỗi", message: res.message);
                        return;
                      }
                      Loaders.successSnackBar(
                          title: "Thành công",
                          message: "Cập nhật mật khẩu thành công");
                      Navigator.of(Get.overlayContext!).pop();
                    } catch (err) {
                      Loaders.successSnackBar(
                          title: "Thất bại!", message: "Từ chối");
                    }
                  },
                  child: const Text("Cập nhật")),
              cancel: OutlinedButton(
                  onPressed: () => Navigator.of(Get.overlayContext!).pop(),
                  child: const Text("Hủy")));
        });
  }
}
