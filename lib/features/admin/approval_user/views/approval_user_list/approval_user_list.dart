import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/approval_user/controllers/approval_user_controller.dart';
import 'package:food_delivery_h2d/features/admin/approval_user/views/detail_approval_user/detail_approval_driver.dart';
import 'package:food_delivery_h2d/features/admin/approval_user/views/detail_approval_user/detail_approval_partner.dart';
import 'package:food_delivery_h2d/features/admin/web_layout.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/driver_register_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/partner_register_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:get/get.dart';

class ApprovalUserList extends StatelessWidget {
  const ApprovalUserList({super.key});

  @override
  Widget build(BuildContext context) {
    final ApprovalUserController controller = Get.put(ApprovalUserController());
    final DriverRegisterController driverRegisterController =
        Get.put(DriverRegisterController());
    final PartnerRegisterController partnerRegisterController =
        Get.put(PartnerRegisterController());

    return WebLayout(
        body: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Text(
              "Danh sách hồ sơ đăng ký",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryTextColor,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: MySizes.md),
              child: Align(
                alignment: Alignment.topRight,
                child: Obx(() => DropdownButton<String>(
                  value: controller.selectedRole.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.updateRole(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: '',
                      child: Text('Tất cả'),
                    ),
                    DropdownMenuItem(
                      value: 'driver',
                      child: Text('Tài xế'),
                    ),
                    DropdownMenuItem(
                      value: 'partner',
                      child: Text('Đối tác'),
                    ),
                  ],
                ),),
              )
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return const Center(
                  child: Text(
                    'Không có người dùng nào',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              if (controller.userList.isEmpty) {
                return const Center(child: Text('Không có người dùng nào'));
              }
              return Expanded(
                child: DataTable2(
                  columnSpacing: 32,
                  minWidth: 800,
                  dividerThickness: 0,
                  horizontalMargin: 12,
                  dataRowHeight: 56,
                  showCheckboxColumn: true,
                  headingTextStyle: Theme.of(context).textTheme.titleSmall,
                  headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => MyColors.primaryBackgroundColor),
                  headingRowDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(MySizes.borderRadiusMd),
                      topRight: Radius.circular(MySizes.borderRadiusMd),
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                  //   color:
                  //       Colors.white,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: MyColors.darkPrimaryColor.withOpacity(0.1),
                  //       blurRadius: 4,
                  //       offset: Offset(0, 4),
                  //     ),
                  //   ],
                  // ),
                  columns: const [
                    DataColumn(
                      label: Text('Họ tên'),
                    ),
                    DataColumn(
                      label: Text('Email'),
                    ),
                    DataColumn(
                      label: Text('SĐT'),
                    ),
                    DataColumn(
                      label: Text('Trạng thái'),
                    ),
                    DataColumn(
                      label: Text('Vai trò'),
                    ),
                    DataColumn(
                      label: Text(""),
                    ),
                  ],
                  rows: controller.userList.map((user) {
                    String statusText = user.status ? "Đã duyệt" : "Chưa duyệt";
                    String roleText = ConvertEnumRole.toDisplayName(
                        UserRole.values.firstWhere(
                            (e) => e.toString() == 'UserRole.${user.role}'));
                    return DataRow(cells: [
                      DataCell(SizedBox(child: Text(user.name))),
                      DataCell(Text(user.email)),
                      DataCell(Text(user.phone)),
                      DataCell(
                        Text(
                          statusText,
                          style: TextStyle(
                              color:
                                  ConvertEnumRole.getStatusColor(user.status)),
                        ),
                      ),
                      DataCell(Text(roleText)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                              size: MySizes.iconMs,
                            ),
                            onPressed: () async {
                              const String roleDriver = "driver";
                              const String rolePartner = "partner";
                              if (user.role == roleDriver) {
                                controller.detailPartner.value = null;
                                controller.detailDriver.value = null;

                                await controller.fetchDetailDriver(user.userId);

                                await driverRegisterController.fetchProvinces();
                                await driverRegisterController.fetchDistricts(
                                    controller.detailDriver.value?.provinceId ??
                                        "0");
                                await driverRegisterController.fetchCommunes(
                                    controller.detailDriver.value?.districtId ??
                                        "0");
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text('Thông tin tài xế'),
                                      content: Obx(() {
                                        if (controller.isLoading.value) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          return DetailApprovalUser(
                                              userSelected: user);
                                        }
                                      }),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await controller
                                                .deleteApprove(user.userId);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Từ chối'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await controller
                                                .approveUser(user.userId);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Duyệt'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (user.role == rolePartner) {
                                controller.detailPartner.value = null;
                                controller.detailDriver.value = null;

                                await controller.fetchDetailPartner(user.userId);

                                await partnerRegisterController
                                    .fetchProvinces();
                                await partnerRegisterController.fetchDistricts(
                                    controller
                                            .detailPartner.value?.provinceId ??
                                        "0");
                                await partnerRegisterController.fetchCommunes(
                                    controller
                                            .detailPartner.value?.districtId ??
                                        "0");
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text(
                                          'Thông tin nhà hàng/quán ăn'),
                                      content: Obx(() {
                                        if (controller.isLoading.value) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          return DetailApprovalPartner(
                                              userSelected: user);
                                        }
                                      }),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await controller
                                                .deleteApprove(user.userId);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Từ chối'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await controller
                                                .approveUser(user.userId);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Duyệt'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          )
                        ],
                      ))
                    ]);
                  }).toList(),
                ),
              );
            })
          ],
        ),
      ),
    ));
  }
}
