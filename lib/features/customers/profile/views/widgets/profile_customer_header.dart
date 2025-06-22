import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/primary_header.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';

class ProfileCustomerHeader extends StatelessWidget {
  const ProfileCustomerHeader({super.key, this.showEdit = false});
  final bool showEdit;

  @override
  Widget build(BuildContext context) {
    const double heightImageHeader = 160.0;
    const top = heightImageHeader - 60.0;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const MyPrimaryHeaderContainer(child: SizedBox(height: heightImageHeader,)),
          Positioned(
              top: top,
              child: Stack(
                children: [
                  const CircleImage(
                    imageUrl: MyImagePaths.imgBunBo,
                  ),
                  if (showEdit)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 24,
                          height: 24,
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
