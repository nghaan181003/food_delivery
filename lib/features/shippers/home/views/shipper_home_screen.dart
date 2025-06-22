import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/notification/views/notification_screen.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/auto_order_dialog.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/map.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/orders_list.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class ShipperHomeScreen extends StatefulWidget {
  const ShipperHomeScreen({super.key});

  @override
  _ShipperHomeScreenState createState() => _ShipperHomeScreenState();
}

class _ShipperHomeScreenState extends State<ShipperHomeScreen> {
  final OrderController controller = Get.put(OrderController());
  final OrderSocketHandler orderSocket = Get.put(OrderSocketHandler());
  final RxBool isShowPopup = false.obs;
  final RxString currentOrderId = ''.obs;
  final orderStream = BehaviorSubject<Order>();
  final Set<String> processedOrders = <String>{};

  @override
  void initState() {
    super.initState();
    _initializeOrderStream();
  }

  @override
  void dispose() {
    orderSocket.removeJoinRoom(LoginController.instance.currentUser.driverId!);
    super.dispose();
  }

  void _initializeOrderStream() {
    OrderController.instance.fetchNewOrders();
    orderSocket.joinRoom(LoginController.instance.currentUser.driverId!);

    orderSocket.listenNewOrderAssigned((newOrder) {
      orderStream.add(newOrder);
    });

    orderStream
        .distinct((prev, curr) => prev.id == curr.id)
        .debounceTime(const Duration(milliseconds: 1500))
        .listen((newOrder) async {
      if (processedOrders.contains(newOrder.id)) {
        return;
      }
      processedOrders.add(newOrder.id);
      if (newOrder.assignedShipperId ==
              LoginController.instance.currentUser.driverId &&
          !isShowPopup.value &&
          currentOrderId.value != newOrder.id &&
          newOrder.driverStatus == 'waiting' &&
          !Get.isDialogOpen!) {
        isShowPopup.value = true;
        currentOrderId.value = newOrder.id;

       
        await Get.dialog(
          AutoOrderDialog(order: newOrder),
          barrierDismissible: false,
        );
        isShowPopup.value = false;
        currentOrderId.value = '';
      }
      if (newOrder.assignedShipperId == null &&
          newOrder.driverStatus == 'waiting') {
        if (!controller.newOrders.any((order) => order.id == newOrder.id)) {
          controller.newOrders.insert(0, newOrder);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapWidget(),
          Container(
            padding: const EdgeInsets.only(
                left: 20, top: 40, right: 20, bottom: 6.0),
            color: MyColors.darkPrimaryColor,
            height: 100,
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipOval(
                        child:
                            LoginController.instance.currentUser.profileUrl !=
                                        "Unknown" &&
                                    LoginController.instance.currentUser
                                        .profileUrl!.isNotEmpty
                                ? Image.network(
                                    LoginController
                                        .instance.currentUser.profileUrl!,
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person,
                                          size: 40, color: Colors.grey);
                                    },
                                  )
                                : const Icon(Icons.person,
                                    size: 30, color: Colors.grey),
                      ),
                    ),
                    if (LoginController.instance.currentUser.workingStatus)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 22, 230, 36),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LoginController.instance.currentUser.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: MyColors.iconColor),
                    ),
                    if (LoginController.instance.currentUser.workingStatus)
                      const Text(
                        'Đang hoạt động',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: MyColors.iconColor),
                      )
                    else
                      const Text(
                        'Không hoạt động',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: MyColors.iconColor),
                      )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(
                            const NotificationScreen(),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_on_outlined,
                          size: 24,
                          color: MyColors.iconColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const OrdersList()
        ],
      ),
    );
  }
}
