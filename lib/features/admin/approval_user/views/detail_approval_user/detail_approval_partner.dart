import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/approval_user/controllers/approval_user_controller.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/partner_register_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:get/get.dart';

class DetailApprovalPartner extends StatelessWidget {
  final UserModel userSelected;

  final PartnerRegisterController partnerRegisterController =
      Get.put(PartnerRegisterController());

  DetailApprovalPartner({super.key, required this.userSelected});

  @override
  Widget build(BuildContext context) {
    final ApprovalUserController controller =
        Get.find<ApprovalUserController>();

    String roleText = ConvertEnumRole.toDisplayName(UserRole.values
        .firstWhere((e) => e.toString() == 'UserRole.${userSelected.role}'));

    controller.fetchDetailPartner(userSelected.userId);
    print("view ${userSelected.userId}");

    String? provinceId = controller.detailPartner.value?.provinceId;
    if (provinceId != null && provinceId.isNotEmpty) {
      partnerRegisterController.fetchDistricts(provinceId);
    }
    String? districtId = controller.detailPartner.value?.districtId;
    if (districtId != null && districtId.isNotEmpty) {
      partnerRegisterController.fetchCommunes(districtId);
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
                          imageUrl: controller.detailPartner.value?.avatarUrl ??
                              MyImagePaths.iconImage,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
                  );
                }),
                const SizedBox(height: MySizes.spaceBtwItems),
                Text(
                  "Ảnh cửa hàng",
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
                          imageUrl:
                              controller.detailPartner.value?.storeFront ??
                                  MyImagePaths.iconImage,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                          "CCCD(mặt trước)",
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
                                          .detailPartner.value?.cccdFrontUrl ??
                                      MyImagePaths.iconImage,
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                          );
                        }),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "CCCD(mặt sau)",
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
                                          .detailPartner.value?.cccdBackUrl ??
                                      MyImagePaths.iconImage,
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
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
                        "Mô tả",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      Text(
                        controller.detailPartner.value?.description ??
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
                        controller.detailPartner.value?.detailAddress ??
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
                  if (partnerRegisterController.communes.isEmpty) {
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
                            controller.detailPartner.value?.communeId ?? ""),
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
                  if (partnerRegisterController.districts.isEmpty) {
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
                            controller.detailPartner.value?.districtId ?? ""),
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
                  if (partnerRegisterController.provinces.isEmpty) {
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
                            controller.detailPartner.value?.provinceId ?? ""),
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
    var province = partnerRegisterController.provinces.firstWhere(
      (p) => p.id == provinceId,
      orElse: () => null,
    );

    if (province == null) {
      return "Tỉnh không xác định";
    }
    return province.name;
  }

  String _getDistrictName(String districtId) {
    if (partnerRegisterController.districts.isEmpty) {
      return "Không có thông tin";
    }

    var district = partnerRegisterController.districts.firstWhere(
      (d) => d.id == districtId,
      orElse: () {
        return null;
      },
    );
    return district?.name ?? "Không có thông tin";
  }

  String _getCommunesName(String communeId) {
    if (partnerRegisterController.communes.isEmpty) {
      return "Không có thông tin";
    }

    var commune = partnerRegisterController.communes.firstWhere(
      (d) => d.id == communeId,
      orElse: () {
        return null;
      },
    );
    return commune?.name ?? "Không có thông tin";
  }
}
