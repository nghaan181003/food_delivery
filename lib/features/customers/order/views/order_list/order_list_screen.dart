import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/history_order_tile_cancelled.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/history_order_tile_delivered.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/ongoing_order_tile.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CustomerOrderListScreen extends StatelessWidget {
  const CustomerOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(CustomerOrderController());

    Future<void> _refreshOrders(List<String> status) async {
      await orderController.fetchOrderByStatuses(status);
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar:
            const CustomAppBar(title: Text("Đơn hàng"), showBackArrow: false),
        backgroundColor: MyColors.primaryBackgroundColor,
        body: Column(
          children: [
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorPadding:
                  const EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
              onTap: (index) {
                final statuses = _getStatusesByIndex(index);
                orderController.fetchOrderByStatuses(statuses);
              },
              tabs: const [
                TabItem(title: "Đang chờ"),
                TabItem(title: "Đang đến"),
                TabItem(title: "Đã giao"),
                TabItem(title: "Đã hủy"),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (orderController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders(["waiting"]),
                        child: buildOrderList(
                            orderController.orders, ["waiting"])),
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders(
                            ["heading_to_rest", "preparing", "delivering"]),
                        child: buildOrderList(orderController.orders,
                            ["heading_to_rest", "preparing", "delivering"])),
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders(["delivered"]),
                        child: buildOrderList(
                            orderController.orders, ["delivered"])),
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders(["cancelled"]),
                        child: buildOrderList(
                            orderController.orders, ["cancelled"])),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getStatusesByIndex(int index) {
    switch (index) {
      case 0:
        return ["waiting"];
      case 1:
        return ["heading_to_rest", "preparing", "delivering"];
      case 2:
        return ["delivered"];
      case 3:
        return ["cancelled"];
      default:
        return ["waiting"];
    }
  }

  Widget buildOrderList(List orders, List<String> statuses) {
    final filtered =
        orders.where((o) => statuses.contains(o.custStatus)).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("Không có đơn hàng!"));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final order = filtered[index];
        if (statuses.contains("delivered")) {
          return HistoryOrderTileDelivered(order: order);
        } else if (statuses.contains("cancelled")) {
          return HistoryOrderTileCancelled(order: order);
        } else {
          return OngoingOrderTile(order: order);
        }
      },
    );
  }
}
