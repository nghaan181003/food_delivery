import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/history_order_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/new_order_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/preparing_order_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../../sockets/handlers/order_socket_handler.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final orderController = Get.put(OrderController());

  final ScrollController _newOrdersScrollController = ScrollController();
  final ScrollController _preparingOrdersScrollController = ScrollController();
  final ScrollController _doneOrdersScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final orderHandler = OrderSocketHandler();
    // orderHandler.listenForOrderCreates((newOrder) {
    //   // Add the new order to the allOrders list
    //   if (newOrder.restStatus == "new" &&
    //       newOrder.restaurantId ==
    //           LoginController.instance.currentUser.partnerId &&
    //       newOrder.assignedShipperId != null) {
    //     orderController.newOrders.insert(0, newOrder);
    //   }
    // });
    orderHandler.joinRoom(LoginController.instance.currentUser.partnerId);
    orderHandler.listenForOrderUpdates((newOrder) {
      if (newOrder.restStatus == "cancelled") {
        orderController.newOrders
            .removeWhere((order) => order.id == newOrder.id);
      } else {
        bool orderExists =
            orderController.newOrders.any((order) => order.id == newOrder.id);
        if (!orderExists) {
          orderController.newOrders.insert(0, newOrder);
        }
      }
    });

    _newOrdersScrollController.addListener(() {
      if (_newOrdersScrollController.position.pixels >=
          _newOrdersScrollController.position.maxScrollExtent - 100) {
        orderController.fetchNewOrders(loadMore: true);
      }
    });

    _preparingOrdersScrollController.addListener(() {
      if (_preparingOrdersScrollController.position.pixels >=
          _preparingOrdersScrollController.position.maxScrollExtent - 100) {
        orderController.fetchPreparingOrders(loadMore: true);
      }
    });

    _doneOrdersScrollController.addListener(() {
      if (_doneOrdersScrollController.position.pixels >=
          _doneOrdersScrollController.position.maxScrollExtent - 100) {
        orderController.fetchCompletedOrders(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _newOrdersScrollController.dispose();
    _preparingOrdersScrollController.dispose();
    _doneOrdersScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(title: Text("Đơn hàng")),
        body: Column(
          children: [
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorPadding:
                  const EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
              onTap: (index) {
                switch (index) {
                  case 0:
                    orderController.fetchNewOrders();
                    break;
                  case 1:
                    orderController.fetchPreparingOrders();
                    break;
                  case 2:
                    orderController.fetchCompletedOrders();
                    break;
                }
              },
              tabs: const [
                TabItem(title: "Đơn mới"),
                TabItem(title: "Đang chuẩn bị"),
                TabItem(title: "Lịch sử"),
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
                    Obx(() => orderController.newOrders.isEmpty
                        ? const Center(child: Text("Không có đơn"))
                        : _buildOrderList(
                            orders: orderController.newOrders,
                            scrollController: _newOrdersScrollController,
                            loadingMore:
                                orderController.isLoadingMoreNewOrders.value,
                            itemBuilder: (order) => NewOrderTile(
                              order: order,
                              handleAccept: () =>
                                  orderController.acceptOrder(order.id),
                              handleCancel: () =>
                                  orderController.handleCancelOrder(order.id),
                            ),
                          )),
                    Obx(() => orderController.preparingOrders.isEmpty
                        ? const Center(child: Text("Không có đơn"))
                        : _buildOrderList(
                            orders: orderController.preparingOrders,
                            scrollController: _preparingOrdersScrollController,
                            loadingMore: orderController
                                .isLoadingMorePreparingOrders.value,
                            itemBuilder: (order) => PreparingOrderTile(
                              order: order,
                              handleDone: () =>
                                  orderController.completeOrder(order.id),
                            ),
                          )),
                    // Done Orders
                    Obx(() => orderController.doneOrders.isEmpty
                        ? const Center(child: Text("Không có đơn"))
                        : _buildOrderList(
                            orders: orderController.doneOrders,
                            scrollController: _doneOrdersScrollController,
                            loadingMore:
                                orderController.isLoadingMoreDoneOrders.value,
                            itemBuilder: (order) =>
                                HistoryOrderTile(order: order),
                          )),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList({
    required List orders,
    required ScrollController scrollController,
    required bool loadingMore,
    required Widget Function(dynamic order) itemBuilder,
  }) {
    return ListView.builder(
      controller: scrollController,
      itemCount: orders.length + (loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < orders.length) {
          return itemBuilder(orders[index]);
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
