import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/update_request/controllers/driver_update_request_controller.dart';
import 'package:food_delivery_h2d/features/admin/web_layout.dart';
import 'package:food_delivery_h2d/features/notification/controllers/notification_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class DriverUpdateRequestScreen extends StatelessWidget {
  DriverUpdateRequestScreen({super.key});
  final controller = Get.put(DriverUpdateRequestController());
  final notificationController = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return WebLayout(
      body: Obx(() {
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
        if (controller.updateList.isEmpty) {
          return const Center(child: Text('Không có người dùng nào'));
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Text(
                  "Danh sách yêu cầu chỉnh sửa thông tin của tài xế",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryTextColor,
                      ),
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Expanded(
                  child: DataTable2(
                    columnSpacing: 24,
                    minWidth: 786,
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
                        label: Text('Họ và tên'),
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
                        label: Text('Ngày gửi'),
                      ),
                      DataColumn(
                        label: Text(""),
                      ),
                    ],
                    rows: controller.updateList.map((updateList) {
                      return DataRow(cells: [
                        DataCell(SizedBox(child: Text(updateList.name))),
                        DataCell(SizedBox(child: Text(updateList.email))),
                        DataCell(SizedBox(child: Text(updateList.phone))),
                        DataCell(
                          Text(
                            updateList.status == 'pending' ? 'Chưa duyệt' : '',
                          ),
                        ),
                        DataCell(Text(
                            MyFormatter.formatDateTime(updateList.createdAt))),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                size: MySizes.iconMs,
                              ),
                              onPressed: () {
                                {
                                  _showUpdateDetailsDialog(
                                      context,
                                      updateList.updatedFields,
                                      updateList.id,
                                      updateList.userId);
                                }
                              },
                            ),
                            const SizedBox(
                              width: MySizes.spaceBtwItems,
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showUpdateDetailsDialog(BuildContext context,
      Map<String, dynamic> updatedFields, String requestId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Các thông tin cần chỉnh sửa')),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: updatedFields.entries.map((entry) {
                if (entry.key == 'profileUrl') {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_getFieldLabel(entry.key)}:'),
                      const SizedBox(width: MySizes.spaceBtwSections),
                      CachedNetworkImage(
                        imageUrl: entry.value,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '${_getFieldLabel(entry.key)}:',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.secondaryTextColor,
                                  ),
                        ),
                        const SizedBox(
                          width: MySizes.sm,
                        ),
                        Text('${entry.value}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                }
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await controller.rejectUpdateRequest(requestId);
                await notificationController
                    .sendRejectUpdateNotification(userId);
                Navigator.of(context).pop();
              },
              child: const Text('Từ chối'),
            ),
            TextButton(
              onPressed: () async {
                await controller.approveUpdate(requestId);
                await notificationController
                    .sendApproveUpdateNotification(userId);
                Navigator.of(context).pop();
              },
              child: const Text('Duyệt'),
            ),
          ],
        );
      },
    );
  }

  String _getFieldLabel(String key) {
    const fieldLabels = {
      'name': 'Họ và tên',
      'phone': 'Số điện thoại',
      'profileUrl': 'Ảnh đại diện',
      'licensePlate': 'Biển số xe'
    };
    return fieldLabels[key] ?? key;
  }
}
