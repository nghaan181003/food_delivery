import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/primary_header.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/profile/controllers/update_profile_driver_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class ProfileDriverHeader extends StatelessWidget {
  const ProfileDriverHeader({super.key, this.showEdit = false});
  final bool showEdit;

  @override
  Widget build(BuildContext context) {
    const double heightImageHeader = 140.0;
    const top = heightImageHeader - 60.0;
    final controller = Get.put(UpdateProfileDriverController());
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const MyPrimaryHeaderContainer(
              child: SizedBox(
            height: heightImageHeader,
          )),
          Positioned(
              top: top,
              child: Stack(
                children: [
                  Obx(() {
                    final profile = controller.profileImage.value;
                    return CircleImage(
                      imageUrl: profile != null
                          ? profile.path
                          : LoginController.instance.currentUser.profileUrl,
                      isLocalImage: profile != null,
                    );
                  }),
                  if (showEdit)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          controller.pickImage(isProfile: true);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: MyColors.darkPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        ]);
  }
}
