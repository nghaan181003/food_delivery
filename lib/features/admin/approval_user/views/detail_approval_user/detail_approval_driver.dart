import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/approval_user/controllers/approval_user_controller.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/driver_register_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:get/get.dart';

class DetailApprovalUser extends StatelessWidget {
  final UserModel userSelected;

  final DriverRegisterController driverRegisterController =
      Get.put(DriverRegisterController());

  DetailApprovalUser({super.key, required this.userSelected});

  @override
  Widget build(BuildContext context) {
    final ApprovalUserController controller =
        Get.find<ApprovalUserController>();

    String roleText = ConvertEnumRole.toDisplayName(UserRole.values
        .firstWhere((e) => e.toString() == 'UserRole.${userSelected.role}'));

    controller.fetchDetailDriver(userSelected.userId);

    String? provinceId = controller.detailDriver.value?.provinceId;
    if (provinceId != null && provinceId.isNotEmpty) {
      driverRegisterController.fetchDistricts(provinceId);
    }
    String? districtId = controller.detailDriver.value?.districtId;
    if (districtId != null && districtId.isNotEmpty) {
      driverRegisterController.fetchCommunes(districtId);
    }
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ảnh hồ sơ",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Obx(() {
                  return Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: controller.detailDriver.value?.profileUrl ??
                              MyImagePaths.iconImage,
                          width: 150,
                        height: 150,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child:
                                  CircularProgressIndicator()), // Show a loading indicator while the image loads
                          errorWidget: (context, url, error) => const Icon(Icons
                              .error), // Show an error icon if the image fails to load
                        )),
                  );
                }),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Giấy phép lái xe (mặt trước)",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        const SizedBox(height: MySizes.spaceBtwItems),
                        Obx(() {
                          return Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    MySizes.borderRadiusSm),
                                child: CachedNetworkImage(
                                  imageUrl: controller.detailDriver.value
                                          ?.licenseFrontUrl ??
                                      MyImagePaths.iconImage,
                                  width: 200,
                                height: 150,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child:
                                          CircularProgressIndicator()), // Show a loading indicator while the image loads
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons
                                          .error), // Show an error icon if the image fails to load
                                )),
                          );
                        }),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Giấy phép lái xe (mặt sau)",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        const SizedBox(height: MySizes.spaceBtwItems),
                        Obx(() {
                          return Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    MySizes.borderRadiusSm),
                                child: CachedNetworkImage(
                                  imageUrl: controller
                                          .detailDriver.value?.licenseBackUrl ??
                                      MyImagePaths.iconImage,
                                  width: 200,
                                height: 150,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child:
                                          CircularProgressIndicator()), // Show a loading indicator while the image loads
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons
                                          .error), // Show an error icon if the image fails to load
                                )),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
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
                    Text(
                      userSelected.name,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: MyColors.primaryTextColor,
                            height: 2,
                          ),
                    )
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
                      width: 200,
                      child: Text(
                        userSelected.email,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    )
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
                      width: 200,
                      child: Text(
                        userSelected.phone,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    )
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
                      width: 200,
                      child: Text(
                        roleText,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Biển số xe",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      Text(
                        controller.detailDriver.value?.licensePlate ??
                            "Không có thông tin",
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: MySizes.spaceBtwItems),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Địa chỉ",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      Text(
                        controller.detailDriver.value?.detailAddress ??
                            "Không có thông tin",
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: MySizes.spaceBtwItems),
                Obx(() {
                  if (driverRegisterController.communes.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phường/ Xã",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      Text(
                        _getCommunesName(
                            controller.detailDriver.value?.communeId ??
                                "Không có thông tin"),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: MySizes.spaceBtwItems),
                Obx(() {
                  if (driverRegisterController.districts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quận/ Huyện",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      Text(
                        _getDistrictName(
                            controller.detailDriver.value?.districtId ??
                                "Không có thông tin"),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: MySizes.spaceBtwItems),
                Obx(() {
                  if (driverRegisterController.provinces.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tỉnh/ Thành phố",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      Text(
                        _getProvinceName(
                            controller.detailDriver.value?.provinceId ??
                                "Không có thông tin"),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getProvinceName(String provinceId) {
    var province = driverRegisterController.provinces.firstWhere(
      (p) => p.id == provinceId,
      orElse: () => null,
    );

    if (province == null) {
      print("Không tìm thấy tỉnh với ID: $provinceId");
      return "Tỉnh không xác định";
    }
    return province.name;
  }

  String _getDistrictName(String districtId) {
    if (driverRegisterController.districts.isEmpty) {
      print("Danh sách quận rỗng!");
      return "Không có thông tin";
    }

    var district = driverRegisterController.districts.firstWhere(
      (d) => d.id == districtId,
      orElse: () {
        print('District ID $districtId not found in districts list!');
        return null;
      },
    );
    return district?.name ?? "Không có thông tin";
  }

  String _getCommunesName(String communeId) {
    if (driverRegisterController.communes.isEmpty) {
      print("Danh sách thành phố rỗng!");
      return "Không có thông tin";
    }

    var commune = driverRegisterController.communes.firstWhere(
      (d) => d.id == communeId,
      orElse: () {
        print('Communes ID $communeId not found in commune list!');
        return null;
      },
    );
    return commune?.name ?? "Không có thông tin";
  }
}
