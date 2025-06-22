import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/my_text_filed.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/profile/controllers/update_profile_driver_controller.dart';
import 'package:food_delivery_h2d/features/shippers/profile/views/widgets/profile_driver_header.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ProfileDriverDetail extends StatelessWidget {
  ProfileDriverDetail({super.key});

  final updateProfileDriverController =
      Get.put(UpdateProfileDriverController());

  void _initTextControllers() {
    final currentUser = LoginController.instance.currentUser;
    updateProfileDriverController.nameController.text = currentUser.name;
    updateProfileDriverController.phoneController.text =
        currentUser.phone;
    updateProfileDriverController.emailController.text = currentUser.email;
    updateProfileDriverController.licensePlateController.text =
        currentUser.licensePlate;
  }

  @override
  Widget build(BuildContext context) {
    _initTextControllers();

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
                  updateProfileDriverController.createDriveUpdate();
                }),
          ],
        ),
        body: Obx(() {
          if (updateProfileDriverController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const ProfileDriverHeader(showEdit: true,),
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
                              textController: updateProfileDriverController
                                  .nameController,
                              hintText: "Tên quán ăn",
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
                              textController: updateProfileDriverController
                                  .phoneController,
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
                              textController: updateProfileDriverController
                                  .emailController,
                              hintText: "Email",
                              readOnly: true,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Biển số xe",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 200,
                            child: MyTextFiled(
                              textController: updateProfileDriverController
                                  .licensePlateController,
                              hintText: "Biển số xe",
                            ),
                          )
                        ],
                      ),
                      // Text(
                      //   "Ngày tham gia",
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .bodySmall!
                      //       .apply(color: MyColors.darkPrimaryTextColor),
                      // ),
                      // const SizedBox(height: MySizes.spaceBtwItems),
                      // MyTextFiled(
                      //   textController: updateProfileDriverController
                      //       .dateController,
                      //   textAlign: TextAlign.left,
                      //   hintText: "Ngày tham gia",
                      //   maxLines: 4,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
