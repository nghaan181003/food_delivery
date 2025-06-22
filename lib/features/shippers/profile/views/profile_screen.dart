import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/changePassword.dart';
import 'package:food_delivery_h2d/features/shippers/profile/controllers/profile_controller.dart';
import 'package:food_delivery_h2d/features/shippers/profile/views/history_driver_update_request.dart';
import 'package:food_delivery_h2d/features/shippers/profile/views/profile_driver_detail.dart';
import 'package:food_delivery_h2d/features/shippers/profile/views/widgets/profile_driver_header.dart';
import 'package:food_delivery_h2d/features/shippers/rating/views/driver_rating.dart';
import 'package:food_delivery_h2d/features/wallet/views/wallet_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Hồ sơ của tôi"),
        showBackArrow: false,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: MySizes.sm),
              child: IconButton(
                onPressed: () {
                  Get.to(() => const HistoryDriverUpdateRequest());
                },
                icon: const Icon(
                  Icons.manage_history_rounded,
                  size: MySizes.iconMd,
                ),
              ),
            ),
          const ChangingPassword(),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const ProfileDriverHeader(),
              Padding(
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Trạng thái hoạt động',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Obx(() => Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  trackOutlineWidth: null,
                                  value: profileController.isWorking.value,
                                  activeColor: Colors.white,
                                  activeTrackColor: MyColors.primaryColor,
                                  onChanged: (value) {
                                    profileController.toggleWorkingStatus();
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 16),
                    //   child: InkWell(
                    //     onTap: () async {
                    //       await authController.getCurrentLocation();
                    //       profileController.addressKey.value++;
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text(
                    //           'Vị trí hiện tại',
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //         const Spacer(),
                    //         Obx(() => SizedBox(
                    //               width: 200,
                    //               child: FutureBuilder<String?>(
                    //                 key: ValueKey(
                    //                     profileController.addressKey.value),
                    //                 future: authController.currentLocation !=
                    //                         null
                    //                     ? profileController
                    //                         .getAddressFromCoordinates(
                    //                         authController
                    //                             .currentLocation!['latitude'],
                    //                         authController
                    //                             .currentLocation!['longitude'],
                    //                       )
                    //                     : Future.value(null),
                    //                 builder: (context, snapshot) {
                    //                   return Text(
                    //                     snapshot.connectionState ==
                    //                             ConnectionState.waiting
                    //                         ? "Đang lấy địa chỉ..."
                    //                         : snapshot.hasData &&
                    //                                 snapshot.data != null
                    //                             ? snapshot.data!
                    //                             : "Chưa có vị trí",
                    //                     style: const TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 14,
                    //                       color: MyColors.secondaryTextColor,
                    //                     ),
                    //                     maxLines: 3,
                    //                     softWrap: true,
                    //                     textAlign: TextAlign.end,
                    //                   );
                    //                 },
                    //               ),
                    //             )),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                   
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Họ và tên',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            LoginController.instance.currentUser.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: MyColors.secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            LoginController.instance.currentUser.email,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: MyColors.secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Biển số xe',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            LoginController.instance.currentUser.licensePlate,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: MyColors.secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ngày tham gia',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            MyFormatter.formatDate(LoginController
                                .instance.currentUser.createdAt
                                .toString()),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: MyColors.secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const DriverRating());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đánh giá',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: MyColors.secondaryTextColor,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const WalletScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ví của tôi',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: MyColors.secondaryTextColor,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(ProfileDriverDetail());
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
