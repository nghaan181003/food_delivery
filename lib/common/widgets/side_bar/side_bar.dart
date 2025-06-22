import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/common/widgets/side_bar/widgets/expand_side_bar.dart';
import 'package:food_delivery_h2d/common/widgets/side_bar/widgets/side_bar_item.dart';
import 'package:food_delivery_h2d/routes/routes.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                right: BorderSide(color: MyColors.dividerColor, width: 1))),
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: MySizes.spaceBtwItems),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                  child: const CircleImage(
                    imageUrl: MyImagePaths.appRed,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(
                height: MySizes.spaceBtwItems,
              ),
              const Column(
                children: [
                  SideBarItem(
                    route: Routes.dashboard,
                    icon: Icons.home_outlined,
                    itemName: "Trang chủ",
                  ),
                  SideBarItem(
                    route: Routes.approveRequest,
                    icon: Icons.file_download_done_rounded,
                    itemName: "Duyệt hồ sơ",
                  ),
                  SideBarItem(
                    route: Routes.userManagement,
                    icon: Icons.manage_accounts_outlined,
                    itemName: "Quản lý tài khoản",
                  ),
                  ExpandableSidebarItem(
                    icon: Icons.drive_file_rename_outline_outlined,
                    itemName: "Yêu cầu chỉnh sửa",
                    children: [
                      SideBarItem(
                        route: Routes.approvePartnerRequest,
                        icon: Icons.storefront,
                        itemName: "Quán ăn",
                      ),
                      SideBarItem(
                        route: Routes.approveDriverRequest,
                        icon: Icons.directions_car,
                        itemName: "Tài xế",
                      ),
                    ],
                  ),
                  SideBarItem(
                      route: Routes.orderManagement,
                      icon: Icons.file_copy_outlined,
                      itemName: "Quản lý đơn hàng"),
                  SideBarItem(
                    route: Routes.config,
                    icon: Icons.settings_suggest_outlined,
                    itemName: "Cấu hình",
                  ),
                  SideBarItem(
                    route: Routes.logout,
                    icon: Icons.logout_outlined,
                    itemName: "Đăng xuất",
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
