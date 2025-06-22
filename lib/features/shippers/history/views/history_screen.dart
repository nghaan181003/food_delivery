import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/history/views/widgets/history_order_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final orderController = Get.put(OrderController());

  Future<void> _refreshOrders(String status) async {
    await orderController.fetchOrderDriverByStatuses([status]);
  }

  @override
  Widget build(BuildContext context) {
    orderController.fetchOrderDriverByStatuses(["heading_to_rest"]);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn hàng'),
          centerTitle: true,
          backgroundColor: MyColors.darkPrimaryColor,
        ),
        backgroundColor: MyColors.primaryBackgroundColor,
        body: Column(
          children: [
            TabBar(
                // tabAlignment: TabAlignment.start,
                // isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                padding: EdgeInsets.zero,
                // indicatorPadding:
                //     EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
                onTap: (index) {
                  final statuses = _getStatusesByIndex(index);
                  orderController.fetchOrderDriverByStatuses(statuses);
                },
                tabs: const [
                  TabItem(title: "Đang đến quán"),
                  TabItem(title: "Đang giao"),
                  TabItem(title: "Đã giao"),
                  TabItem(title: "Đã hủy"),
                ]),
            Expanded(child: Obx(() {
              if (orderController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders("heading_to_rest"),
                        child: buildOrderList(
                            orderController.orders, ["heading_to_rest"])),
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders("delivering"),
                        child: buildOrderList(
                            orderController.orders, ["delivering"])),
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders("delivered"),
                        child: buildOrderList(
                            orderController.orders, ["delivered"])),
                    RefreshIndicator(
                        onRefresh: () => _refreshOrders("cancelled"),
                        child: buildOrderList(
                            orderController.orders, ["cancelled"])),
                  ]);
            }))
          ],
        ),
      ),
    );
  }

  List<String> _getStatusesByIndex(int index) {
    switch (index) {
      case 0:
        return ["heading_to_rest"];
      case 1:
        return ["delivering"];
      case 2:
        return ["delivered"];
      case 3:
        return ["cancelled"];
      default:
        return ["heading_to_rest"];
    }
  }

  Widget buildOrderList(List orders, List<String> statuses) {
    final filtered =
        orders.where((o) => statuses.contains(o.driverStatus)).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("Không có đơn hàng!"));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final order = filtered[index];
        return HistoryOrderTile(order: order);
      },
    );
  }
}
