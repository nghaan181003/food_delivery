import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/my_text_filed.dart';
import 'package:food_delivery_h2d/features/admin/user_management/controllers/update_user_management_controller.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:get/get.dart';

class DetailUser extends StatelessWidget {
  final UserModel selectedUser;

  final UpdateUserManagementController updateUserManagementController =
      Get.put(UpdateUserManagementController());

  DetailUser({super.key, required this.selectedUser});
  void fetchUserDetail() {
    updateUserManagementController.nameController.text = selectedUser.name;
    updateUserManagementController.emailController.text = selectedUser.email;
    updateUserManagementController.phoneNumberController.text =
        selectedUser.phone;

    String roleText = ConvertEnumRole.toDisplayName(UserRole.values
        .firstWhere((e) => e.toString() == 'UserRole.${selectedUser.role}'));

    // Set roleController as an RxString
    updateUserManagementController.roleController.value = roleText;
  }

  @override
  Widget build(BuildContext context) {
    fetchUserDetail();

    return SizedBox(
      width: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tên",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    SizedBox(
                      width: 280,
                      child: MyTextFiled(
                          textController:
                              updateUserManagementController.nameController,
                          hintText: "Nhập tên"),
                    ),
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
                      width: 280,
                      child: MyTextFiled(
                          textController:
                              updateUserManagementController.emailController,
                          hintText: "Nhập email"),
                    ),
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
                      width: 280,
                      child: MyTextFiled(
                          textController: updateUserManagementController
                              .phoneNumberController,
                          hintText: "Nhập số điện thoại"),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vai trò",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    SizedBox(
                      child: Obx(() {
                        return DropdownButton<String>(
                          value: updateUserManagementController
                                  .roleController.value.isNotEmpty
                              ? updateUserManagementController
                                  .roleController.value
                              : null,
                          items: UserRole.values.map((UserRole role) {
                            return DropdownMenuItem<String>(
                              value: ConvertEnumRole.toDisplayName(role),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child:
                                    Text(ConvertEnumRole.toDisplayName(role)),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              updateUserManagementController
                                  .roleController.value = value;
                            }
                          },
                          hint: Text(
                            "Chọn vai trò",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: MyColors.secondaryTextColor,
                                    ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
