import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/devices/devices_utils.dart';

class WebHeader extends StatelessWidget implements PreferredSizeWidget {
  const WebHeader({super.key, this.scaffoldKey, this.toggleDrawer});

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function? toggleDrawer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: MyColors.dividerColor, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: MySizes.md, vertical: MySizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (MyDeviceUtils.isDesktopScreen(context)) {
              toggleDrawer!();
            } else {
              scaffoldKey?.currentState?.openDrawer();
            }
          },
          icon: const Icon(Icons.more_vert, size: MySizes.iconMd, color: MyColors.darkPrimaryColor,),
        ),
        actions: [
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.notifications_outlined,
          //       size: MySizes.iconMs,
          //       color: MyColors.darkPrimaryColor,
          //     )),
          const SizedBox(
            width: MySizes.spaceBtwItems / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleImage(
                imageUrl: MyImagePaths.appRed,
                width: 40,
                height: 40,
              ),
              const SizedBox(
                width: MySizes.sm,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Admin",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: MyColors.darkPrimaryColor),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(MyDeviceUtils.getAppBarHeight() + 15);
}
