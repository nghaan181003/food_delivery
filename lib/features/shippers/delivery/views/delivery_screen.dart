import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/button/floating_button.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/delivery_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/suggestion_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/route_screen.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/suggestion_order_list.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/widgets/customer_tab.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/widgets/restaurant_tab.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class DeliveryScreen extends StatefulWidget {
  final Order order;
  const DeliveryScreen({super.key, required this.order});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final DeliveryController deliveryController = Get.put(DeliveryController());
  final OrderController orderController = Get.find();
  final OrderSocketHandler orderHandler = OrderSocketHandler();
  final _suggestionOrder = Get.put(SuggestionController());

  final GlobalKey _moreBtnKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    orderHandler.joinRoom(widget.order.id);
    orderHandler.joinRoom(LoginController.instance.currentUser.driverId);
    deliveryController.startLocationTracking(widget.order.id, isMock: false);
    _listenSuggestionOrder();
    _listenRejectionOrder();
  }

  @override
  void dispose() {
    orderHandler.removeJoinRoom(widget.order.id);
    deliveryController.onClose();
    super.dispose();
  }

  void _listenSuggestionOrder() async {
    orderHandler.listenSuggestionOrder((order) {
      print("Suggested Order ${order.id}");
      _suggestionOrder.addSuggestionOrder(order);
    });
  }

  void _listenRejectionOrder() async {
    orderHandler.listenRejectionOrder((order) {
      print("Rejected Order ${order.toString()}");
      _suggestionOrder.removeSugesstionOrder(order.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Giao hàng'),
          centerTitle: true,
          backgroundColor: MyColors.darkPrimaryColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
            ),
            onPressed: () async {
              Get.back();
              await orderController.fetchNewOrders();
            },
          ),
          actions: [
            IconButton(
                key: _moreBtnKey,
                onPressed: () async {
                  final RenderBox button = _moreBtnKey.currentContext!
                      .findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final Offset position =
                      button.localToGlobal(Offset.zero, ancestor: overlay);

                  await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy + button.size.height,
                      position.dx + button.size.width,
                      0,
                    ),
                    items: _suggestionOrder.mergeOrders.map((order) {
                      return PopupMenuItem(
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DeliveryScreen(order: order),
                            ),
                          );
                        },
                        value: order,
                        child: ListTile(
                          title: Text("Đơn: ${order.id}"),
                          subtitle: Text("${order.totalPrice} đ"),
                        ),
                      );
                    }).toList(),
                  );
                },
                icon: const Icon(Icons.more_vert)),
          ],
          bottom: const TabBar(
            dividerColor: Colors.white,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Nhà hàng'),
              Tab(text: 'Khách hàng'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RestaurantTab(order: widget.order),
            CustomerTab(order: widget.order),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingButtons(
          buttons: [
            if (widget.order.driverStatus != "canceled" &&
                widget.order.driverStatus != "delivered")
              FloatingActionButton.extended(
                heroTag: 'map_btn',
                onPressed: () =>
                    deliveryController.openGoogleMapsForOrder(widget.order),
                icon: const Icon(Icons.directions, color: Colors.white),
                label: const Text(
                  'Chỉ đường',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: MyColors.darkPrimaryColor,
              ),
            FloatingActionButton.extended(
              heroTag: 'route_btn',
              onPressed: () {
                // TODO: naviagate to route screen
                Get.to(() => RouteScreen(
                      orders: [..._suggestionOrder.mergeOrders, widget.order],
                    ));
              },
              icon: const Icon(Icons.route, color: Colors.white),
              label: const Text(
                'Lộ trình',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blue,
            ),
            FloatingActionButton.extended(
              heroTag: 'merge_btn',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const SuggestionOrderList(),
                );
              },
              icon: const Icon(Icons.merge, color: Colors.white),
              label: const Text(
                'Ghép đơn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
