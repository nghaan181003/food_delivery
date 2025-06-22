import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/suggestion_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/order_tile.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/suggestion_order_widget.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class SuggestionOrderList extends StatefulWidget {
  const SuggestionOrderList({super.key});

  @override
  State<SuggestionOrderList> createState() => _SuggestionOrderListState();
}

class _SuggestionOrderListState extends State<SuggestionOrderList> {
  final _suggestionOrder = SuggestionController.instance;
  final _orderController = OrderController.instance;

  final _orderHandler = OrderSocketHandler();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _suggestionOrder.getSuggestionOrder();
  }

  Future<void> handleAcceptTap(Order order) async {
    Map<String, dynamic> newStatus = {
      "custStatus": "heading_to_rest",
      "driverStatus": "heading_to_rest",
      "restStatus": "new"
    };

    await _suggestionOrder.acceptSuggestionOrder(order);

    await _orderController.updateOrderStatus(
      LoginController.instance.currentUser.driverId,
      orderId: order.id,
      newStatus: newStatus,
    );

    _orderHandler.updateStatusOrder(order.id, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.1,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              color: MyColors.primaryBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Obx(() {
              return _suggestionOrder.isEmpty
                  ? const Center(
                      child: Text("Chưa tìm thấy đơn ghép phù hơp"),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: _suggestionOrder.suggestedOrder.length,
                      itemBuilder: (context, index) {
                        final orderItem =
                            _suggestionOrder.suggestedOrder[index];
                        return SuggestionOrderWidget(
                            onReject: () {
                              _suggestionOrder
                                  .rejectSuggestionOrder(orderItem.id);
                            },
                            onAccept: () async {
                              handleAcceptTap(orderItem);
                            },
                            order: orderItem);
                      });
            }),
          );
        });
  }
}
