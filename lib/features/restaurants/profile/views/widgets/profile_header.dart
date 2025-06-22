import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/image_header.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/controllers/update_profile_restaurant_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.showEdit = false});
  final bool showEdit;

  @override
  Widget build(BuildContext context) {
    const double heightImageHeader = 180.0;
    const top = heightImageHeader - 40.0;
    final controller = Get.put(UpdateProfileRestaurantController());

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Obx(() {
            final imageFile = controller.storeFrontImage.value;
            return ImageHeader(
              imageUrl: imageFile != null
                  ? imageFile.path
                  : LoginController.instance.currentUser.storeFront,
              height: heightImageHeader,
              isLocalImage: imageFile != null,
            );
          }),
        ),
        if (showEdit)
          Positioned(
            top: heightImageHeader - 30,
            right: 0,
            child: TextButton(
              onPressed: () => controller.pickImage(isAvatar: false),
              child: const Text(
                "Sửa ảnh",
                style: TextStyle(color: MyColors.dividerColor),
              ),
            ),
          ),
        Positioned(
          top: top,
          child: Stack(
            children: [
              Obx(() {
                final avatarFile = controller.avatarImage.value;
                return CircleImage(
                  imageUrl: avatarFile != null
                      ? avatarFile.path
                      : LoginController.instance.currentUser.avatarUrl,
                  isLocalImage: avatarFile != null,
                );
              }),
              if (showEdit)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      controller.pickImage(isAvatar: true);
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
          ),
        ),
      ],
    );
  }
}
