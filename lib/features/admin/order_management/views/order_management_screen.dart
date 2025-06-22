import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/order_management/controllers/order_management_controller.dart';
import 'package:food_delivery_h2d/features/admin/order_management/views/order_detail.dart';
import 'package:food_delivery_h2d/features/admin/web_layout.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderManagementController());
    final searchController = TextEditingController();

    return WebLayout(
        body: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Text(
                "Danh sách đơn hàng",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryTextColor,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  MySizes.spaceBtwItems,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: MySizes.sm),
                      height: 45,
                      width: 400,
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (value) {
                          final query = value.trim();
                          controller.searchOrderById(id: query);
                        },
                        onChanged: (value) {
                          final query = value.trim();
                          if (query == "") {
                            controller.fetchAllOrder();
                          } else {
                            controller.searchOrderById(id: query);
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: MySizes.md),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              searchController.clear();
                              controller.fetchAllOrder();
                            },
                          ),
                          hintText: "Nhập id của đơn hàng cần tìm",
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: MyColors.secondaryTextColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(MySizes.borderRadiusLg),
                            borderSide: const BorderSide(
                                color: MyColors.secondaryTextColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(MySizes.borderRadiusLg),
                            borderSide: const BorderSide(
                                color: MyColors.secondaryTextColor),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => DropdownButton<String>(
                          value: controller.selectedStatus.value,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.updateStatus(newValue);
                            }
                          },
                          items: StatusHelper.orderStatusTranslations.entries
                              .map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.orderList.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Hiện đang không có đơn hàng'),
                  ));
                }
                return SizedBox(
                  height: 410,
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
                    columns: const [
                      DataColumn(
                        label: Center(
                          child: Text(
                            'Mã đơn hàng',
                          ),
                        ),
                      ),
                      DataColumn(
                          label: Center(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Trạng thái"),
                          Text("khách hàng"),
                        ],
                      ))),
                      DataColumn(
                          label: Center(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Trạng thái'),
                          Text('tài xế'),
                        ],
                      ))),
                      DataColumn(
                          label: Center(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Trạng thái'),
                          Text('đối tác'),
                        ],
                      ))),
                      DataColumn(
                          label: Center(
                        child: Text('Ngày đặt hàng'),
                      )),
                      DataColumn(label: Text(""), numeric: true),
                    ],
                    rows: controller.orderList.map((order) {
                      return DataRow(cells: [
                        DataCell(SelectableText(order.id)),
                        DataCell(Center(
                          child: Text(
                            StatusHelper
                                    .custStatusTranslations[order.custStatus] ??
                                '',
                            style: TextStyle(
                                color: StatusHelper.getColor(
                                    'custStatus', order.custStatus)),
                          ),
                        )),
                        DataCell(Center(
                          child: Text(
                            StatusHelper.driverStatusTranslations[
                                    order.driverStatus] ??
                                '',
                            style: TextStyle(
                                color: StatusHelper.getColor(
                                    'driverStatus', order.driverStatus ?? '')),
                          ),
                        )),
                        DataCell(Center(
                          child: Text(
                            StatusHelper
                                    .restStatusTranslations[order.restStatus] ??
                                '',
                            style: TextStyle(
                                color: StatusHelper.getColor(
                                    'restStatus', order.restStatus ?? '')),
                          ),
                        )),
                        DataCell(Center(
                          child: Text(
                              MyFormatter.formatDateTime(order.orderDatetime)),
                        )),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                size: MySizes.iconMs,
                              ),
                              onPressed: () async {
                                await controller.fetchOrderById(order.id);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text("Chi tiết đơn hàng"),
                                        content: Obx(() {
                                          if (controller
                                              .isLoadingDetail.value) {
                                            return const CircularProgressIndicator();
                                          } else {
                                            return OrderDetail(id: order.id);
                                          }
                                        }),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Đóng'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                controller.deleteOrderById(order.id);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                size: MySizes.iconMs,
                                color: Colors.red,
                              ),
                            )
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                );
              }),
              Obx(() {
                final isPrevEnabled =
                    controller.page > 1 && !controller.isLoading.value;
                final isNextEnabled =
                    controller.hasMore.value && !controller.isLoading.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: isPrevEnabled
                          ? () {
                              controller.previousPage();
                            }
                          : null,
                      child: Text(
                        "Trang trước",
                        style: TextStyle(
                          color: isPrevEnabled
                              ? MyColors.darkPrimaryTextColor
                              : MyColors.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
                    Text(controller.page.toString()),
                    const SizedBox(width: MySizes.md),
                    InkWell(
                      onTap: isNextEnabled
                          ? () {
                              controller.fetchAllOrder(loadMore: true);
                            }
                          : null,
                      child: Text(
                        "Trang kế",
                        style: TextStyle(
                          color: isNextEnabled
                              ? MyColors.darkPrimaryTextColor
                              : MyColors.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    ));
  }
}
